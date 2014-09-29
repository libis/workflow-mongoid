# encoding: utf-8

require 'libis/workflow/mongoid/work_item'

class TestItem
  include LIBIS::Workflow::Mongoid::WorkItem
  run_class 'TestRun'
end