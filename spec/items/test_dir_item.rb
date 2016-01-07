# encoding: utf-8
require 'libis/workflow'
require_relative 'test_item'

class TestDirItem < TestItem

  include ::Libis::Workflow::Base::DirItem

  def name=(dir)
    raise RuntimeError, "'#{dir}' is not a directory" unless File.directory? dir
    super dir
  end

  def name
    self.properties['name'] || super
  end

end