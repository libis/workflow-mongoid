# encoding: utf-8
require 'LIBIS_Tools'

require_relative 'test_item'

class TestFileItem < TestItem
  include ::LIBIS::Workflow::FileItem

  def name=(file)
    raise RuntimeError, "'#{file}' is not a file" unless File.file? file
    super file
    properties[:checksum] = ::LIBIS::Tools::Checksum.hexdigest(file, :SHA256)
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