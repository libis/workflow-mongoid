# encoding: utf-8
require 'LIBIS_Workflow'
require 'libis/workflow/mongoid/base_model'

module LIBIS
  module Workflow
    module Mongoid
      class WorkflowTask < LIBIS::Workflow::Task
        include BaseModel

        field :name, type: String
        field :options, type: Hash, default: -> { Hash.new }
        field :default_options, type: Hash, default: -> { Hash.new }

        has_many :workflow_tasks, inverse_of: :parent, class_name: 'LIBIS::Workflow::Mongoid::WorkflowTask'
        belongs_to :parent, inverse_of: :tasks, class_name: 'LIBIS::Workflow::Mongoid::WorkflowTask'

        before_validation :set_name

        index({name: 1}, {unique: 1})

        def initialize(parent, cfg = nil)
          super parent
          configure cfg
        end

        def configure(cfg)
          self.name = cfg[:name] || cfg[:class] || self.class.name
          (cfg[:tasks] || []).each do |task_cfg|
            task_class = Task
            task_class = task_cfg[:class].constantize if task_cfg[:class]
            task_instance = task_class.new self, task_cfg.symbolize_keys!
            workflow_tasks << task_instance
          end

        end

        def tasks
          self[:workflow_task_ids].each_with_object([]) { |id, a| h = self.workflow_tasks.find(id); a << h } rescue []
        end

        def set_name
          self[:name] ||= self[:class_name]
        end

        def config
          {
              name: self[:name],
              class: self[:class_name],
              options: self[:options],
              tasks: self.tasks.map { |task| task.config }
          }.delete_if { |_, v| (v.nil? || (v.respond_to?(:empty?) && v.empty?)) rescue false }
        end

        def set_config(cfg)
          self.name = cfg[:name] || cfg[:class] || self.class.name
          self.options = self.default_options.merge(cfg)
          self.name = cfg[:name] || cfg[:class] || self.class.name
          (cfg[:tasks] || []).each do |task_cfg|
            task_class = Task
            task_class = task_cfg[:class].constantize if task_cfg[:class]
            task_instance = task_class.new self, task_cfg.symbolize_keys!
            workflow_tasks << task_instance
          end
        end

        def set_parent(p)
          self.parent = p
        end

        private

      end

    end
  end
end
