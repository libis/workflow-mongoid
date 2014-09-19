# encoding: utf-8
require 'fileutils'

require 'libis/workflow/base/run'
require 'libis/workflow/mongoid/workitems/work_item'

module LIBIS
  module Workflow
    module Mongoid

      class Run
        include ::LIBIS::Workflow::Base::Run
        include ::LIBIS::Workflow::Mongoid::WorkItemBase

        store_in collection: 'workflow_runs'

        attr_accessor :tasks

        field :start_date, type: Time, default: -> { Time.now }
        belongs_to :workflow, inverse_of: :workflow_runs, class_name: 'LIBIS::Workflow::Mongoid::Workflow'

        has_many :items, class_name: 'LIBIS::Workflow::Mongoid::WorkItem', inverse_of: :run,
                 dependent: :destroy, autosave: true, order: :created_at.asc

        set_callback(:destroy, :before) do |document|
          wd = document.work_dir
          FileUtils.rmtree wd if Dir.exist? wd
        end

        index start_date: 1

        def run(opts = {})
          self.tasks = []
          self.items = []
          super opts
        end

        def parent
          nil
        end

      end

    end
  end
end
