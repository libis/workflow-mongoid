# encoding: utf-8
require 'digest'

require 'libis/exceptions'
require 'libis/workflow/workitems'

class ChecksumTester < ::LIBIS::Workflow::Task
  def process
    return unless item_type? TestFileItem

    md5sum = ::Digest::MD5.hexdigest(File.read(workitem.long_name))

    raise ::LIBIS::WorkflowError "Checksum test failed for #{workitem.long_name}" unless workitem.properties[:checksum] == md5sum
  end
end
