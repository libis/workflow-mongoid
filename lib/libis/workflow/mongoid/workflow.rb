# encoding: utf-8
require 'libis/workflow/mongoid/base_model'
require_relative 'workflow_task'
require_relative 'workflow_input'

module LIBIS
  module Workflow
    module Mongoid

      class Workflow < LIBIS::Workflow::Definition
        include BaseModel

        field :name, type: String
        field :description, type: String

        embeds_many :workflow_inputs, class_name: 'LIBIS::Workflow::Mongoid::WorkflowInput'
        has_and_belongs_to_many :workflow_tasks, inverse_of: nil, class_name: 'LIBIS::Workflow::Mongoid::WorkflowTask'

        has_many :workflow_runs, inverse_of: :workflow, class_name: 'LIBIS::Workflow::Mongoid::WorkflowRun'

        index({name: 1}, {unique: 1})

        def run(opts = {})

          wfr = self.workflow_runs.build
          wfr.save
          wfr.run opts
          wfr

        end

        def tasks
          self[:workflow_task_ids].each_with_object([]) { |id, a| h = workflow_tasks.find(id); a << h } rescue []
        end

        def inputs
          self.workflow_inputs
        end

        def config
          {
              name: self[:name],
              description: self[:description],
              start_object: self[:start_object],
              tasks: self.tasks.map { |task| task.config },
              input: self.inputs.map { |input| input.config }
          }
        end

        def set_config(cfg)
          LIBIS::Workflow::Mongoid::WorkflowRun.require_all

          super(cfg)

          cfg[:tasks].each  do |m|
            task_class = Task
            task_class    = m[:class].constantize if m[:class]
            task_instance = task_class.new nil, m.symbolize_keys!
            self.tasks << task_instance
          end

        end

      end

    end
  end
end
