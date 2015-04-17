# encoding: utf-8
require 'libis-workflow-mongoid'

class TestRun
  include ::Libis::Workflow::Mongoid::Run

  item_class 'TestItem'
  workflow_class 'TestWorkflow'

  def name; 'TestRun'; end

end