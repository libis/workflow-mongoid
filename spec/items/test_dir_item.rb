# encoding: utf-8
require_relative 'test_item'

class TestDirItem < TestItem
  include ::LIBIS::Workflow::DirItem

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