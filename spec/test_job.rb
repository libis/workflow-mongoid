# encoding: utf-8

require 'libis/workflow/mongoid/job'

class TestJob
  include ::Libis::Workflow::Mongoid::Job
  run_class 'TestRun'
  workflow_class 'TestWorkflow'
end