# encoding: utf-8

require 'libis/workflow/mongoid/workflow'

class TestWorkflow
  include ::LIBIS::Workflow::Mongoid::Workflow
  run_class 'TestRun'
end