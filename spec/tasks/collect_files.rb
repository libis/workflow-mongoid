# encoding: utf-8
require 'libis/exceptions'

require_relative '../items'

class CollectFiles < ::LIBIS::Workflow::Task

  def process
    if item_type? TestRun
      dir = TestDirItem.new
      dir.name = workitem.options[:dirname]
      workitem << dir
    elsif item_type? TestDirItem
      workitem.collect(TestFileItem, recursive: true)
    else
      # do nothin
    end
  end

end
