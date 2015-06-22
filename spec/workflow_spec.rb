# encoding: utf-8

require 'rspec'
require 'stringio'

require 'libis-workflow-mongoid'

require_relative 'spec_helper'
require_relative 'test_workflow'
require_relative 'items'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

describe 'TestWorkflow' do

  let(:dirname) { File.absolute_path(File.join(File.dirname(__FILE__), 'items')) }

  let(:logoutput) { StringIO.new }

  let(:workflow) {
    # noinspection RubyResolve
    ::Libis::Workflow::Mongoid.configure do |cfg|
      cfg.itemdir = File.join(File.dirname(__FILE__), 'items')
      cfg.taskdir = File.join(File.dirname(__FILE__), 'tasks')
      cfg.workdir = File.join(File.dirname(__FILE__), 'work')
      cfg.logger = Logger.new logoutput
      cfg.set_log_formatter
      cfg.logger.level = Logger::DEBUG
      cfg.database_connect 'mongoid.yml', :test
    end

    TestWorkflow.create_indexes
    TestRun.create_indexes
    TestFileItem.create_indexes
    TestDirItem.create_indexes

    TestWorkflow.each { |wf| wf.destroy }

    workflow = TestWorkflow.new
    workflow.configure(
        name: 'TestWorkflow',
        description: 'Workflow for testing',
        tasks: [
            {class: 'CollectFiles', recursive: true},
            {
                name: 'ProcessFiles',
                subitems: true,
                tasks: [
                    {class: 'ChecksumTester',  recursive: true},
                    {class: 'CamelizeName',  recursive: true}
                ]
            }
        ],
        input: {
            dirname: {default: '.', propagate_to: 'CollectFiles#location'},
            checksum_type: {default: 'SHA1', propagate_to: 'ProcessFiles/ChecksumTester'}
        }
    )
    workflow.save
    workflow
  }

  let(:run) {
    # noinspection RubyStringKeysInHashInspection
    workflow.run(dirname: dirname, checksum_type: 'SHA256')
  }

  it 'should contain three tasks' do

    expect(workflow.config[:tasks].size).to eq 3
    expect(workflow.config[:tasks].first[:class]).to eq 'CollectFiles'
    expect(workflow.config[:tasks].last[:class]).to eq '::Libis::Workflow::Tasks::Analyzer'

  end

  it 'should camelize the workitem name' do

    expect(run.options[:dirname]).to eq dirname
    expect(run.items.count).to eq 1
    expect(run.items.first.class).to eq TestDirItem
    expect(run.items.first.count).to eq 4
    expect(run.items.first.first.class).to eq TestFileItem

    run.items.first.each_with_index do |x, i|
      expect(x.name).to eq %w'TestDirItem.rb TestFileItem.rb TestItem.rb TestRun.rb'[i]
    end
  end

  it 'should return expected debug output' do

    expect(run.summary['DEBUG']).to eq 57
    expect(run.log_history.count).to eq 8
    expect(run.status_log.count).to eq 6
    expect(run.items.first.log_history.count).to eq 25
    expect(run.items.first.status_log.count).to eq 8

    sample_out = <<STR
DEBUG -- CollectFiles - TestRun : Started
DEBUG -- CollectFiles - TestRun : Processing subitem (1/1): items
DEBUG -- CollectFiles - items : Started
DEBUG -- CollectFiles - items : Processing subitem (1/4): test_dir_item.rb
DEBUG -- CollectFiles - items/test_dir_item.rb : Started
DEBUG -- CollectFiles - items/test_dir_item.rb : Completed
DEBUG -- CollectFiles - items : Processing subitem (2/4): test_file_item.rb
DEBUG -- CollectFiles - items/test_file_item.rb : Started
DEBUG -- CollectFiles - items/test_file_item.rb : Completed
DEBUG -- CollectFiles - items : Processing subitem (3/4): test_item.rb
DEBUG -- CollectFiles - items/test_item.rb : Started
DEBUG -- CollectFiles - items/test_item.rb : Completed
DEBUG -- CollectFiles - items : Processing subitem (4/4): test_run.rb
DEBUG -- CollectFiles - items/test_run.rb : Started
DEBUG -- CollectFiles - items/test_run.rb : Completed
DEBUG -- CollectFiles - items : 4 of 4 subitems passed
DEBUG -- CollectFiles - items : Completed
DEBUG -- CollectFiles - TestRun : 1 of 1 subitems passed
DEBUG -- CollectFiles - TestRun : Completed
DEBUG -- ProcessFiles - TestRun : Started
DEBUG -- ProcessFiles - TestRun : Processing subitem (1/1): items
DEBUG -- ProcessFiles - items : Started
DEBUG -- ProcessFiles - items : Running subtask (1/2): ChecksumTester
DEBUG -- ProcessFiles/ChecksumTester - items : Started
DEBUG -- ProcessFiles/ChecksumTester - items : Processing subitem (1/4): test_dir_item.rb
DEBUG -- ProcessFiles/ChecksumTester - items/test_dir_item.rb : Started
DEBUG -- ProcessFiles/ChecksumTester - items/test_dir_item.rb : Completed
DEBUG -- ProcessFiles/ChecksumTester - items : Processing subitem (2/4): test_file_item.rb
DEBUG -- ProcessFiles/ChecksumTester - items/test_file_item.rb : Started
DEBUG -- ProcessFiles/ChecksumTester - items/test_file_item.rb : Completed
DEBUG -- ProcessFiles/ChecksumTester - items : Processing subitem (3/4): test_item.rb
DEBUG -- ProcessFiles/ChecksumTester - items/test_item.rb : Started
DEBUG -- ProcessFiles/ChecksumTester - items/test_item.rb : Completed
DEBUG -- ProcessFiles/ChecksumTester - items : Processing subitem (4/4): test_run.rb
DEBUG -- ProcessFiles/ChecksumTester - items/test_run.rb : Started
DEBUG -- ProcessFiles/ChecksumTester - items/test_run.rb : Completed
DEBUG -- ProcessFiles/ChecksumTester - items : 4 of 4 subitems passed
DEBUG -- ProcessFiles/ChecksumTester - items : Completed
DEBUG -- ProcessFiles - items : Running subtask (2/2): CamelizeName
DEBUG -- ProcessFiles/CamelizeName - items : Started
DEBUG -- ProcessFiles/CamelizeName - Items : Processing subitem (1/4): test_dir_item.rb
DEBUG -- ProcessFiles/CamelizeName - Items/test_dir_item.rb : Started
DEBUG -- ProcessFiles/CamelizeName - Items/TestDirItem.rb : Completed
DEBUG -- ProcessFiles/CamelizeName - Items : Processing subitem (2/4): test_file_item.rb
DEBUG -- ProcessFiles/CamelizeName - Items/test_file_item.rb : Started
DEBUG -- ProcessFiles/CamelizeName - Items/TestFileItem.rb : Completed
DEBUG -- ProcessFiles/CamelizeName - Items : Processing subitem (3/4): test_item.rb
DEBUG -- ProcessFiles/CamelizeName - Items/test_item.rb : Started
DEBUG -- ProcessFiles/CamelizeName - Items/TestItem.rb : Completed
DEBUG -- ProcessFiles/CamelizeName - Items : Processing subitem (4/4): test_run.rb
DEBUG -- ProcessFiles/CamelizeName - Items/test_run.rb : Started
DEBUG -- ProcessFiles/CamelizeName - Items/TestRun.rb : Completed
DEBUG -- ProcessFiles/CamelizeName - Items : 4 of 4 subitems passed
DEBUG -- ProcessFiles/CamelizeName - Items : Completed
DEBUG -- ProcessFiles - Items : Completed
DEBUG -- ProcessFiles - TestRun : 1 of 1 subitems passed
DEBUG -- ProcessFiles - TestRun : Completed
STR
    sample_out = sample_out.lines.to_a
    output = logoutput.string.lines

    expect(output.count).to eq sample_out.count
    output.each_with_index do |o, i|
      expect(o.strip).to match(/#{Regexp.escape sample_out[i].strip}$/)
    end

  end

  it 'find workflow' do
    workflow
    wf = TestWorkflow.first
    expect(wf.nil?).to eq false
    expect(wf.name).to eq 'TestWorkflow'
    expect(wf.description).to eq 'Workflow for testing'
    expect(wf.input.count).to eq 2
    expect(wf.input[:dirname][:default]).to eq '.'
    expect(wf.config[:tasks].count).to eq 3
    expect(wf.config[:tasks][0][:class]).to eq 'CollectFiles'
    expect(wf.config[:tasks][0][:recursive]).to eq true
    expect(wf.config[:tasks][1][:name]).to eq 'ProcessFiles'
    expect(wf.config[:tasks][1][:subitems]).to eq true
    expect(wf.config[:tasks][1][:tasks].count).to eq 2
    expect(wf.config[:tasks][1][:tasks][0][:class]).to eq 'ChecksumTester'
    expect(wf.config[:tasks][1][:tasks][0][:recursive]).to eq true
    expect(wf.config[:tasks][1][:tasks][1][:class]).to eq 'CamelizeName'
    expect(wf.config[:tasks][1][:tasks][1][:recursive]).to eq true
    expect(wf.config[:tasks][2][:class]).to eq '::Libis::Workflow::Tasks::Analyzer'
  end

  # noinspection RubyResolve
  it 'find run' do
    run
    wf = TestWorkflow.first
    expect(wf.workflow_runs.count).to be > 0
    wf_run = wf.workflow_runs.first
    expect(wf_run.is_a? TestRun).to eq true
    expect(wf_run.nil?).to eq false
    expect(wf_run.options[:dirname]).to eq dirname
    expect(wf_run.properties[:ingest_failed]).to eq false
    expect(wf_run.log_history.count).to eq 8
    expect(wf_run.status_log.count).to eq 6
    expect(wf_run.summary[:DEBUG]).to eq 57
  end

  # noinspection RubyResolve
  it 'find first item' do
    run
    wf = TestWorkflow.first
    expect(wf.workflow_runs.first.items.count).to be > 0
    item = wf.workflow_runs.first.items.first
    expect(item.nil?).to eq false
    expect(item.is_a? TestDirItem).to eq true
    expect(item.properties[:name]).to eq 'Items'
    expect(item.properties[:ingest_failed]).to eq false
    expect(item.log_history.count).to eq 25
    expect(item.status_log.count).to eq 8
    expect(item.summary[:DEBUG]).to eq 49
  end

end