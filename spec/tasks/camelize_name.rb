# encoding: utf-8
require 'libis/tools/extend/string'
require 'libis-workflow'

class CamelizeName < ::Libis::Workflow::Task

  def process(item)
    return unless (item.is_a?(TestFileItem) || item.is_a?(TestDirItem))
    item.properties['name'] = item.name.camelize
    item.save!
  end

end
