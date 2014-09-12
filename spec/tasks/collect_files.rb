# encoding: utf-8
require 'LIBIS_Workflow_Mongoid'

require_relative '../items'

class CollectFiles < ::LIBIS::Workflow::Mongoid::Task
  def process
    check_item_type TestDirItem
    collect_files workitem
  end

  def collect_files(dir_item)
    base_dir = dir_item.dirname
    dir_item.dir_list.sort.each do |dirname|
      subdir_item = TestDirItem.new(File.join base_dir, dirname)
      collect_files subdir_item
      workitem << subdir_item
    end
    dir_item.file_list.sort.each do |filename|
      workitem << TestFileItem.new(File.join base_dir, filename)
    end
  end

end
