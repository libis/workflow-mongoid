# encoding: utf-8
require 'backports/rails/string'

require 'libis/workflow/workitems'

class CamelizeName < ::LIBIS::Workflow::Task

  def process(item)
    item.properties[:name] = item.long_name.camelize
  end

end
