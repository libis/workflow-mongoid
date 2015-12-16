# encoding: utf-8
require 'libis/workflow'
require_relative 'test_item'

class TestDirItem
  include ::Libis::Workflow::Base::DirItem
  include ::Libis::Workflow::Mongoid::WorkItemBase

  def name=(dir)
    raise RuntimeError, "'#{dir}' is not a directory" unless File.directory? dir
    super dir
  end

  def name
    self.properties[:name] || super
  end

end