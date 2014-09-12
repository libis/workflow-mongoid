# encoding: utf-8
require 'LIBIS_Workflow_Mongoid'
require 'backports/rails/string'

class CamelizeName < ::LIBIS::Workflow::Mongoid::Task
  def process
    workitem.name = workitem.name.camelize
  end
end
