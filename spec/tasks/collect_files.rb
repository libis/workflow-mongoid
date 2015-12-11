# encoding: utf-8
require 'libis/exceptions'

require_relative '../items'

class CollectFiles < ::Libis::Workflow::Task

  parameter location: '.',
            description: 'Dir location to start scanning for files.'
  parameter subdirs: false,
            description: 'Look for files in subdirs too.'
  parameter selection: nil,
            description: 'Only select files that match the given regular expression. Ignored if empty.'

  def process(item)
    if item.is_a? TestRun
      puts 'item is a TestRun'
      add_item(item, parameter(:location))
    elsif item.is_a? TestDirItem
      puts 'item is a TestDirItem'
      collect_files(item, item.fullpath)
    end
  end

  def collect_files(item, dir)
    puts "Collecting files from dir #{dir}"
    glob_string = dir
    glob_string = File.join(glob_string, '**') if parameter(:subdirs)
    glob_string = File.join(glob_string, '*')

    Dir.glob(glob_string).select do |x|
      parameter(:selection) && !parameter(:selection).empty? ? x =~ Regexp.new(parameter(:selection)) : true
    end.sort.each do |file|
      puts "File #{file} passed filter"
      next if %w'. ..'.include? file
      puts "File #{file} passed . / .. check"
      add_item(item, file)
    end
  end

  def add_item(item, file)
    puts "Adding item #{file} to #{item}"
    child = if File.file?(file)
              puts 'item is a file'
              TestFileItem.new
            elsif File.directory?(file)
              puts 'item is a dir'
              TestDirItem.new
            else
              puts 'item is something else'
              error 'Bad file type encountered: %s', file
              nil
            end
    unless child
      puts 'Failed to create child item'
      return
    end
    puts 'Created child item'
    child.filename = file
    puts "Child name #{child}"
    item << child
    puts 'Child added to parent item'
    puts "Now #{item.count} - #{item.items.count} subitems:"
    item.items.each do |i|
      puts " - #{i}"
    end
  end

end
