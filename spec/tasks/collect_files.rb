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
      add_item(item, parameter(:location))
    elsif item.is_a? TestDirItem
      collect_files(item, item.fullpath)
    end
  end

  def collect_files(item, dir)
    glob_string = dir
    glob_string = File.join(glob_string, '**') if parameter(:subdirs)
    glob_string = File.join(glob_string, '*')

    Dir.glob(glob_string).select do |x|
      parameter(:selection) && !parameter(:selection).empty? ? x =~ Regexp.new(parameter(:selection)) : true
    end.sort.each do |file|
      next if %w'. ..'.include? file
      add_item(item, file)
    end
  end

  def add_item(item, file)
    child = if File.file?(file)
              TestFileItem.new
            elsif File.directory?(file)
              TestDirItem.new
            else
              error 'Bad file type encountered: %s', file
              nil
            end
    unless child
      return
    end
    child.filename = file
    item << child
  end

end
