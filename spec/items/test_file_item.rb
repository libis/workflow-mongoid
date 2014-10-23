# encoding: utf-8
require 'LIBIS_Tools'

require_relative 'test_item'

class TestFileItem < TestItem
  include ::LIBIS::Workflow::FileItem

  def filename=(file)
    raise RuntimeError, "'#{file}' is not a file" unless File.file? file
    set_checksum :SHA256, ::LIBIS::Tools::Checksum.hexdigest(file, :SHA256)
    super file
  end

  def name
    self.properties[:name] || super
  end

  def filesize
    properties[:size]
  end

  def fixity_check(checksum)
    properties[:checksum] == checksum
  end

end