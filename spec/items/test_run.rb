# encoding: utf-8
require 'libis-workflow-mongoid'

class TestRun
  include ::Libis::Workflow::Mongoid::Run

  item_class 'TestItem'
  job_class 'TestJob'

  def name; 'TestRun'; end

end