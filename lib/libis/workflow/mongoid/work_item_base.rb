# encoding: utf-8
require 'libis-workflow'
require_relative 'dynamic'

module Libis
  module Workflow
    module Mongoid

      module WorkItemBase

        class Options
          include Libis::Workflow::Mongoid::Dynamic
          embedded_in :work_item, class_name: 'Libis::Workflow::Mongoid::WorkItem'
        end

        class Properties
          include Libis::Workflow::Mongoid::Dynamic
          embedded_in :work_item, class_name: 'Libis::Workflow::Mongoid::WorkItem'
        end

        class Summary
          include Libis::Workflow::Mongoid::Dynamic
          embedded_in :work_item, class_name: 'Libis::Workflow::Mongoid::WorkItem'
        end

        def self.included(klass)
          klass.class_eval do
            include Libis::Workflow::Base::WorkItem
            include Libis::Workflow::Mongoid::Base

            store_in collection: 'workflow_items'

            embeds_one :options, class_name: Libis::Workflow::Mongoid::WorkItemBase::Options.to_s
            embeds_one :properties, class_name: Libis::Workflow::Mongoid::WorkItemBase::Properties.to_s
            embeds_one :summary, class_name: Libis::Workflow::Mongoid::WorkItemBase::Summary.to_s

            has_many :logs, as: :logger, class_name: Libis::Workflow::Mongoid::LogEntry.to_s,
                     dependent: :destroy, autosave: true, order: :_id.asc do
              def log_history
                where(:status.exists => false)
              end

              def status_log
                where(:status.exists => true)
              end
            end

            has_many :items, as: :parent, class_name: Libis::Workflow::Mongoid::WorkItem.to_s,
                     dependent: :destroy, autosave: true, order: :c_at.asc

            belongs_to :parent, polymorphic: true

            set_callback(:destroy, :before) do |document|
              # noinspection RubyResolve
              document.logs.each { |log| log.destroy! }
            end

            set_callback(:initialize, :after) do |document|
              document.options = {}
              document.properties = {}
              document.summary = {}
            end

          end
        end

        def each
          self.items.each { |item| yield item }
        end

        def log_history
          # noinspection RubyResolve
          self.logs.log_history.all || []
        end

        def status_log
          # noinspection RubyResolve
          self.logs.status_log.all || []
        end

        protected

        def add_log_entry(msg)
          # noinspection RubyResolve
          self.logs.build(msg)
        end

        def add_status_log(info)
          # noinspection RubyResolve
          self.logs.build(info)
        end

      end

    end
  end
end
