# encoding: utf-8

require 'libis/workflow/mongoid/workflow'

class TestWorkflow
  include ::Libis::Workflow::Mongoid::Workflow
  job_class 'TestJob'
end