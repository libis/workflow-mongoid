# encoding: utf-8
require 'libis/workflow/mongoid/workitems/dir_item'

class TestDirItem < ::LIBIS::Workflow::Mongoid::DirItem

  def name=(dir)
    raise RuntimeError, "'#{dir}' is not a directory" unless File.directory? dir
    super dir
  end

  def file_list
    return [] unless long_name
    Dir.entries(long_name).select { |f| File.file? File.join(long_name, f) }
  end

  def dir_list
    return [] unless long_name
    Dir.entries(long_name).select { |f| File.directory? File.join(long_name, f) }.reject { |f| %w'. ..'.include? f }
  end

end