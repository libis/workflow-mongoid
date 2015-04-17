# encoding: utf-8

require 'libis/workflow/mongoid/work_item'

class TestItem
  include Libis::Workflow::Mongoid::WorkItem
  run_class 'TestRun'
end