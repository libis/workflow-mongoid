# encoding: utf-8
require 'LIBIS_Workflow_Mongoid'

class TestRun
  include ::LIBIS::Workflow::Mongoid::Run

  item_class 'TestItem'
  workflow_class 'TestWorkflow'

  def name; 'TestRun'; end

end