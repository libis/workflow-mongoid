# encoding: utf-8
require 'libis/tools/checksum'

require 'libis/exceptions'
require 'libis/workflow/workitems'

class ChecksumTester < ::LIBIS::Workflow::Task

  parameter checksum_type: 'MD5',
            description: 'Checksum type to use.',
            constraint: ::LIBIS::Tools::Checksum::CHECKSUM_TYPES.map {|x| x.to_s}
  parameter checksum_file: nil, description: 'File with checksums of the files.'

  def process(item)
    return unless item.is_a? TestFileItem

    checksum_type = options[:checksum_type]
    checksum = ::LIBIS::Tools::Checksum.hexdigest(item.long_name, checksum_type.to_sym)
    unless item.properties[:checksum] == checksum
      raise ::LIBIS::WorkflowError, "Checksum test #{checksum_type} failed for #{item.long_name}"
    end
  rescue
    warn "Checksum type '#{self.options[:checksum_type]}' not supported. Check ignored."
  end

end
