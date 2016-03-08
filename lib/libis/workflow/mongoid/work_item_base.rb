# encoding: utf-8
require 'libis-workflow'

module Libis
  module Workflow
    module Mongoid

      module WorkItemBase

        def self.included(klass)
          klass.class_eval do
            include Libis::Workflow::Base::WorkItem
            include Libis::Workflow::Mongoid::Base

            store_in collection: 'workflow_items'

            field :options, type: Hash, default: -> { Hash.new }
            field :properties, type: Hash, default: -> { Hash.new }
            field :summary, type: Hash, default: -> { Hash.new }

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

          end
        end

        def log_history
          # noinspection RubyResolve
          self.logs.log_history.all || []
        end

        def status_log
          # noinspection RubyResolve
          self.logs.status_log.all || []
        end

        def add_item(item)
          if item.parent
            item.parent = nil
          end
          super
        end

        def get_items
          self.items.to_a
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
