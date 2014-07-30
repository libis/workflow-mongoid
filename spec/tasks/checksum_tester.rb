# encoding: utf-8
require 'LIBIS_Workflow_Mongoid'
require 'digest'

class ChecksumTester < ::LIBIS::Workflow::Mongoid::WorkflowTask
  def process
    check_item_type TestFileItem

    md5sum = ::Digest::MD5.hexdigest(File.read(workitem.filename))

    raise ::LIBIS::WorkflowError "Checksum test failed for #{workitem.filename}" unless workitem.properties[:checksum] == md5sum
  end
end
