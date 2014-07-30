# encoding: utf-8
require 'LIBIS_Workflow_Mongoid'

class TestDirItem < ::LIBIS::Workflow::Mongoid::WorkItem

  def dirname
    dir = options[:dirname]
    if dir
      raise RuntimeError, "'#{dir}' is not a directory" unless File.directory? dir
    end
    dir
  end

  def name
    @name ||= dirname
  end

  def name=(n)
    @name = n
  end

  def to_string
    name
  end

  def file_list
    return [] unless dirname
    Dir.entries(dirname).select { |f| File.file? File.join(dirname, f) }
  end

  def dir_list
    return [] unless dirname
    Dir.entries(dirname).select { |f| File.directory? File.join(dirname, f) }.reject { |f| %w'. ..'.include? f }
  end
end