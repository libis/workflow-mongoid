# encoding: utf-8
require 'LIBIS_Workflow_Mongoid'

class TestFileItem < ::LIBIS::Workflow::Mongoid::FileItem

  def initialize(file)
    super()
    raise RuntimeError, "'#{file}' is not a file" unless File.file? file
    set_file file
  end

  def name
    @name ||= filename
  end

  def name=(n)
    @name = n
  end

  def to_string
    name
  end

  def filesize
    properties[:size]
  end

  def fixity_check(checksum)
    properties[:checksum] == checksum
  end

end