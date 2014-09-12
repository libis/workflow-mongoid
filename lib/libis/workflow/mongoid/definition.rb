# encoding: utf-8
require 'libis/workflow/mongoid/base_model'
require_relative 'task'
require_relative 'input'

module LIBIS
  module Workflow
    module Mongoid

      class Definition < LIBIS::Workflow::Definition
        include BaseModel

        field :name, type: String
        field :description, type: String

        embeds_many :inputs, class_name: 'LIBIS::Workflow::Mongoid::Input'
        has_and_belongs_to_many :tasks, inverse_of: :workflow, class_name: 'LIBIS::Workflow::Mongoid::Task'

        has_many :runs, inverse_of: :workflow, class_name: 'LIBIS::Workflow::Mongoid::Run'

        index({name: 1}, {unique: 1})

        def run(opts = {})

          wfr = self.runs.build
          wfr.save
          wfr.run opts
          wfr

        end

        def tasks
          self[:task_ids].each_with_object([]) { |id, a| h = tasks.find(id); a << h } rescue []
        end

        def input
          self.input
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

          puts ENV
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
