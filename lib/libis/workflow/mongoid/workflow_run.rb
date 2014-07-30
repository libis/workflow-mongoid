# encoding: utf-8
require 'LIBIS_Workflow'
require 'mongoid/document'
require 'mongoid_indifferent_access'
require 'fileutils'

module LIBIS
  module Workflow
    module Mongoid

      class WorkflowRun < LIBIS::Workflow::WorkflowRun
        include ::Mongoid::Document
        include ::Mongoid::Timestamps
        include ::Mongoid::Extensions::Hash::IndifferentAccess

        field :start_date, type: Time, default: -> { Time.now }
        belongs_to :workflow, inverse_of: :workflow_runs, class_name: 'LIBIS::Workflow::Mongoid::WorkflowDefinition'

        set_callback(:destroy, :before) do |document|
          wd = document.get_work_dir false
          FileUtils.rmtree wd if Dir.exist? wd
        end

        def set_workflow(wf)
          self.workflow = wf
        end

        def to_string
          self.options[:name]
        end

        def name
          "#{self.workflow.name}-#{self.start_date.strftime('%Y%m%d%H%M%S')}"
        end

        def get_work_dir(create = true)
          work_dir = File.join(Config.workdir, self.name)
          FileUtils.mkpath work_dir unless Dir.exist?(work_dir) && create
          work_dir
        end

        def tasks
          self.workflow.tasks
        end

        def self.require_all
          super
          Config.require_all(Config.taskdir)
          Config.require_all(Config.itemdir)
        end

      end

    end
  end
end
