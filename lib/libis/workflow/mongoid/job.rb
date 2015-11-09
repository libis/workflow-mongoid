# encoding: utf-8

require 'libis/workflow/base/job'
require 'libis/workflow/mongoid/base'

module Libis
  module Workflow
    module Mongoid

      module Job

        def self.included(klass)
          klass.class_eval do
            include ::Libis::Workflow::Base::Job
            include ::Libis::Workflow::Mongoid::Base

            store_in collection: 'workflow_jobs'

            field :name, type: String
            field :description, type: String
            field :input, type: Hash, default: -> { Hash.new }
            field :run_object, type: String

            index({name: 1}, {unique: 1})

            def klass.run_class(run_klass)
              has_many :runs, inverse_of: :job, class_name: run_klass.to_s,
                       dependent: :destroy, autosave: true, order: :c_at.asc
            end

            def klass.workflow_class(workflow_klass)
              belongs_to :workflow, inverse_of: :jobs, class_name: workflow_klass.to_s
            end

            # def create_run_object
            #   # noinspection RubyResolve
            #   self.runs.build
            # end

          end

        end

      end
    end
  end
end
