# encoding: utf-8
require 'libis-workflow'

module Libis
  module Workflow
    module Mongoid

      module WorkItemBase

        def self.included(klass)
          klass.class_eval do
            include ::Libis::Workflow::Base::WorkItem
            include Libis::Workflow::Mongoid::Base

            field :options, type: Hash, default: -> { Hash.new }
            field :properties, type: Hash, default: -> { Hash.new }

            has_many :logs, as: :logger, class_name: 'Libis::Workflow::Mongoid::LogEntry',
                     dependent: :destroy, autosave: true, order: :_id.asc do
              def log_history
                where(:status.exists => false)
              end

              def status_log
                where(:status.exists => true)
              end
            end

            # def destroy
            #   # noinspection RubyResolve
            #   self.logs.each { |log| log.destroy }
            # end

            set_callback(:destroy, :before) do |document|
              # noinspection RubyResolve
              document.logs.each { |log| log.destroy! }
            end

            field :summary, type: Hash, default: -> { Hash.new }
          end

        end

        def item_count
          self.items.size
        end

        def add_item(item)
          return self unless item and item.is_a? Libis::Workflow::Mongoid::WorkItem
          self.items << item
          self.save!
          self
        end

        alias :<< :add_item

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

        def add_status_log(message, task = nil)
          # noinspection RubyResolve
          self.logs.build(
              task: task,
              status: message
          )
        end

      end

    end
  end
end
