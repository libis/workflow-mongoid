# encoding: utf-8
require 'fileutils'

require 'libis/workflow/base/run'
require 'libis/workflow/mongoid/work_item_base'

module Libis
  module Workflow
    module Mongoid

      module Run
        # extend ActiveSupport::Concern

        def self.included(klass)
          klass.class_eval do
            include ::Libis::Workflow::Base::Run
            include ::Libis::Workflow::Mongoid::WorkItemBase

            store_in collection: 'workflow_runs'

            field :start_date, type: Time, default: -> { Time.now }

            set_callback(:destroy, :before) do |document|
              document.items.each { |item| item.destroy }
              wd = document.work_dir
              FileUtils.rmtree wd if wd && !wd.blank? && Dir.exist?(wd)
            end

            index start_date: 1

            def klass.job_class(job_klass)
              belongs_to :job, inverse_of: :runs, class_name: job_klass.to_s
            end

            def klass.item_class(item_klass)
              has_many :items, inverse_of: :run, class_name: item_klass.to_s,
                       dependent: :destroy, autosave: true, order: :c_at.asc
            end
          end
        end

        def run
          self.tasks = []
          self.items = []
          # noinspection RubySuperCallWithoutSuperclassInspection
          super
        end

        # Add a child work item
        #
        # @param [Libis::Workflow::Mongoid::WorkItem] item to be added to the child list :items
        def add_item(item)
          # noinspection RubyResolve
          item.run = self
          super
        end

        alias_method :<<, :add_item

        def parent
          nil
        end

        def parent=(_)
          nil
        end

      end

    end
  end
end
