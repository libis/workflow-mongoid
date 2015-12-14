# encoding: utf-8

require 'rspec'
require 'stringio'

require 'libis-workflow-mongoid'

require_relative 'spec_helper'
require_relative 'test_job'
require_relative 'test_workflow'
require_relative 'items'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

describe 'TestWorkflow' do

  before(:context) do
    @dirname = File.absolute_path(File.join(File.dirname(__FILE__), 'items'))
    @logoutput = StringIO.new

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

    @workflow = TestWorkflow.find_or_initialize_by(name: 'TestWorkflow')
    @workflow.configure(
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
    @workflow.save

    @job = TestJob.find_or_initialize_by(name: 'TestJob')
    @job.configure(
            name: 'TestJob',
            description: 'Job for testing',
            workflow: @workflow,
            run_object: 'TestRun',
            input: {dirname: dirname, checksum_type: 'SHA256'},
    )

    # noinspection RubyResolve
    @job.runs.each { |run| run.destroy! }
    @job.save
    @run = @job.execute

  end

  def dirname; @dirname; end
  def logoutput; @logoutput; end
  def workflow; @workflow; end
  def job; @job; end
  def run; @run; end

  it 'should contain three tasks' do

    expect(workflow.config[:tasks].size).to eq 3
    expect(workflow.config[:tasks].first[:class]).to eq 'CollectFiles'
    expect(workflow.config[:tasks].last[:class]).to eq '::Libis::Workflow::Tasks::Analyzer'

  end

  it 'should camelize the workitem name' do

    expect(run.options['CollectFiles'][:location]).to eq dirname

    def print_item(item, indent = 0)
      puts "#{indent * 2 * ' '} - #{item.name}"
      item.items.get_items.each do |i|
        print_item(i, indent + 1)
      end
    end
    print_item(run)

    expect(run.count).to eq 1
    expect(run.first.class).to eq TestDirItem
    expect(run.first.count).to eq 4
    expect(run.first.first.class).to eq TestFileItem

    expect(run.get_items.count).to eq 1
    expect(run.get_items.first.class).to eq TestDirItem
    expect(run.get_items.first.count).to eq 4
    expect(run.get_items.first.get_items.first.class).to eq TestFileItem

    run.items.first.each_with_index do |x, i|
      expect(x.name).to eq %w'TestDirItem.rb TestFileItem.rb TestItem.rb TestRun.rb'[i]
    end
  end

  it 'should return expected debug output' do

    expect(run.summary[:DEBUG]).to eq 23
    expect(run.log_history.count).to eq 8
    expect(run.status_log.count).to eq 8
    item = run.items.first
    expect(item.log_history.count).to eq 15
    expect(item.status_log.count).to eq 6
    expect(item.summary[:DEBUG]).to eq 15

    sample_out = <<STR
DEBUG -- CollectFiles - TestRun : Processing subitem (1/1): items
DEBUG -- CollectFiles - items : Processing subitem (1/4): test_dir_item.rb
DEBUG -- CollectFiles - items : Processing subitem (2/4): test_file_item.rb
DEBUG -- CollectFiles - items : Processing subitem (3/4): test_item.rb
DEBUG -- CollectFiles - items : Processing subitem (4/4): test_run.rb
DEBUG -- CollectFiles - items : 4 of 4 subitems passed
DEBUG -- CollectFiles - TestRun : 1 of 1 subitems passed
DEBUG -- ProcessFiles - TestRun : Running subtask (1/2): ChecksumTester
DEBUG -- ProcessFiles/ChecksumTester - TestRun : Processing subitem (1/1): items
DEBUG -- ProcessFiles/ChecksumTester - items : Processing subitem (1/4): test_dir_item.rb
DEBUG -- ProcessFiles/ChecksumTester - items : Processing subitem (2/4): test_file_item.rb
DEBUG -- ProcessFiles/ChecksumTester - items : Processing subitem (3/4): test_item.rb
DEBUG -- ProcessFiles/ChecksumTester - items : Processing subitem (4/4): test_run.rb
DEBUG -- ProcessFiles/ChecksumTester - items : 4 of 4 subitems passed
DEBUG -- ProcessFiles/ChecksumTester - TestRun : 1 of 1 subitems passed
DEBUG -- ProcessFiles - TestRun : Running subtask (2/2): CamelizeName
DEBUG -- ProcessFiles/CamelizeName - TestRun : Processing subitem (1/1): items
DEBUG -- ProcessFiles/CamelizeName - Items : Processing subitem (1/4): test_dir_item.rb
DEBUG -- ProcessFiles/CamelizeName - Items : Processing subitem (2/4): test_file_item.rb
DEBUG -- ProcessFiles/CamelizeName - Items : Processing subitem (3/4): test_item.rb
DEBUG -- ProcessFiles/CamelizeName - Items : Processing subitem (4/4): test_run.rb
DEBUG -- ProcessFiles/CamelizeName - Items : 4 of 4 subitems passed
DEBUG -- ProcessFiles/CamelizeName - TestRun : 1 of 1 subitems passed
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
    my_job = TestJob.first
    expect(my_job).to eq job
    expect(my_job.runs.all.count).to eq 1
    my_run = my_job.runs.all.first
    expect(my_run).to eq run
  end

  # noinspection RubyResolve
  it 'find first item' do
    item = run.items.first
    expect(item.nil?).to eq false
    expect(item.is_a? TestDirItem).to eq true
    expect(item.properties[:name]).to eq 'Items'
    expect(item.properties[:ingest_failed]).to eq false
  end

end