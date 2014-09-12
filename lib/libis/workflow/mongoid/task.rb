# encoding: utf-8
require 'LIBIS_Workflow'
require 'libis/workflow/mongoid/base_model'

module LIBIS
  module Workflow
    module Mongoid
      class Task < LIBIS::Workflow::Task
        include BaseModel

        belongs_to :parent, inverse_of: :tasks, class_name: 'LIBIS::Workflow::Mongoid::Task'

        field :name, type: String
        field :class, type: String
        field :options, type: Hash, default: -> { Hash.new }

        has_many :tasks, inverse_of: :parent, class_name: 'LIBIS::Workflow::Mongoid::Task'

        before_validation :set_name

        index({name: 1}, {unique: 1})

        def configure(cfg)
          self.name = cfg[:name] || cfg[:class] || self.class.name

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

        def config=(cfg)
          self.name = cfg[:name] || cfg[:class] || self.class.name
          self.options = self.default_options.merge(cfg)
        end

        def set_parent(p)
          self.parent = p
        end

        private

      end

    end
  end
end
