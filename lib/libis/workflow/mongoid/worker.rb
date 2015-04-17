# encoding: utf-8

require 'libis/workflow/worker'

module Libis
  module Workflow
    module Mongoid

      class Worker < Libis::Workflow::Worker

        def get_workflow(workflow_config)
          workflow_name = workflow_config[:name] if workflow_config.is_a? Hash
          workflow_name ||= workflow_config.to_s
          workflow = ::Libis::Workflow::Mongoid.find(name: workflow_name).first
          raise RuntimeError.new "Workflow #{workflow_name} not found" unless workflow.is_a? ::Libis::Workflow::Mongoid::Workflow
          workflow
        end

      end
    end
  end
end
