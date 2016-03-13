# encoding: utf-8
require 'libis-tools'
require 'libis-workflow'

require_relative 'test_item'

class TestFileItem < TestItem

  include ::Libis::Workflow::Base::FileItem

  def filename=(file)
    raise RuntimeError, "'#{file}' is not a file" unless File.file? file
    set_checksum :SHA256, ::Libis::Tools::Checksum.hexdigest(file, :SHA256)
    super file
  end

  def name
    self.properties['name'] || super
  end

  def filesize
    properties['size']
  end

  def fixity_check(checksum)
    properties['checksum'] == checksum
  end

end