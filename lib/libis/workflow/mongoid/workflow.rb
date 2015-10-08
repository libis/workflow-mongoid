# encoding: utf-8

require 'libis/workflow/base/workflow'
require 'libis/workflow/mongoid/base'
require 'libis/tools/config_file'

module Libis
  module Workflow
    module Mongoid

      module Workflow

        def self.included(klass)
          klass.class_eval do
            include ::Libis::Workflow::Base::Workflow
            include ::Libis::Workflow::Mongoid::Base

            store_in collection: 'workflow_definitions'

            field :name, type: String
            field :description, type: String
            field :config, type: Hash, default: -> { Hash.new }

            index({name: 1}, {unique: 1})

            def klass.run_class(run_klass)
              has_many :workflow_runs, inverse_of: :workflow, class_name: run_klass.to_s,
                       dependent: :destroy, autosave: true, order: :created_at.asc
            end

            def klass.load(file_or_hash)
              config = Libis::Tools::ConfigFile.new
              config << file_or_hash
              return nil if config.empty?
              workflow = self.new
              workflow.configure(config.to_h)
              workflow
            end

            def create_run_object
              # noinspection RubyResolve
              self.workflow_runs.build
            end

            def restart(id, task = nil)
              # noinspection RubyResolve
              run_object = self.workflow_runs.select { |run| run.id == id }
              raise WorkflowError, "Run #{id} not found" unless run_object
              run_object.restart task
              run_object
            end

          end

        end

      end
    end
  end
end
