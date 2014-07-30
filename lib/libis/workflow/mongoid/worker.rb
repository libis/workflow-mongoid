# encoding: utf-8
require 'LIBIS_Workflow'
require 'libis/workflow/mongoid/workflow_definition'

module LIBIS
  module Workflow
    module Mongoid
      class Worker
        attr_accessor :workflow_name, :options, :log_path
        attr_reader :workflow

        def initialize(workflow_def, options = {})
          @workflow_name = workflow_def.name
          @log_path = options.delete :log_path
          @options = options.dup
          @workflow = LIBIS::Workflow::Mongoid::WorkflowDefinition.find_by(name: @workflow_name)
          raise RuntimeError.new("Workflow '#{@workflow_name}' not found") unless @workflow
        end

        def start
          start_logging
          @workflow.run @options.merge(interactive: true)
        end

        def run
          start_logging
          @workflow.run @options.merge(interactive: false)
        end

        private

        def start_logging
          if log_path
            Config.logger = ::Logger.new(
                File.join(log_path, "#{@workflow_name}.log"),
                (options.delete(:log_shift_age) || 'daily'),
                (options.delete(:log_shift_size) || 1024 ** 2)
            )
            Config.logger.formatter = ::Logger::Formatter.new
            Config.logger.level = ::Logger::DEBUG
          end
        end

      end
    end
  end
end
