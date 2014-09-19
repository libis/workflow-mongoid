# encoding: utf-8

require 'libis/workflow/worker'

module LIBIS
  module Workflow
    module Mongoid

      class Worker < LIBIS::Workflow::Worker

        def get_workflow(workflow_config)
          workflow_name = workflow_config[:name] if workflow_config.is_a? Hash
          workflow_name ||= workflow_config.to_s
          workflow = ::LIBIS::Workflow::Mongoid.find(name: workflow_name).first
          raise RuntimeError.new "Workflow #{workflow_name} not found" unless workflow.is_a? ::LIBIS::Workflow::Mongoid::Workflow
          workflow
        end

      end
    end
  end
end
