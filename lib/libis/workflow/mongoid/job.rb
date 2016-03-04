# encoding: utf-8

require 'libis/workflow/base/job'
require 'libis/workflow/mongoid/base'

module Libis
  module Workflow
    module Mongoid

      class Job

        include ::Libis::Workflow::Base::Job
        include ::Libis::Workflow::Mongoid::Base

        store_in collection: 'workflow_jobs'

        field :name, type: String
        field :description, type: String
        field :input, type: Hash, default: -> { Hash.new }
        field :run_object, type: String

        index({name: 1}, {unique: 1})

        has_many :runs, as: :job, dependent: :destroy, autosave: true, order: :c_at.asc

        belongs_to :workflow, polymorphic: true
        embeds_one :log_config

        def logger
          self.log_config.logger("#{self.name}.log") rescue nil
        end

        # def create_run_object
        #   # noinspection RubyResolve
        #   self.runs.build
        # end

      end

    end
  end
end
