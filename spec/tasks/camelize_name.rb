# encoding: utf-8
require 'backports/rails/string'

require 'libis/workflow/workitems'

class CamelizeName < ::LIBIS::Workflow::Task

  def process(item)
    return unless (item.is_a?(TestFileItem) || item.is_a?(TestDirItem))
    item.properties[:name] = item.name.camelize
  end

end
