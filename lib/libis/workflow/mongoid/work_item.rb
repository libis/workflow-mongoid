require 'libis-workflow'

module Libis
  module Workflow
    module Mongoid

      class WorkItem

        include Libis::Workflow::Base::WorkItem
        include Libis::Workflow::Mongoid::Base

        store_in collection: 'workflow_items'

        field :options, type: Hash, default: -> { Hash.new }
        field :properties, type: Hash, default: -> { Hash.new }
        field :summary, type: Hash, default: -> { Hash.new }

        index({_id: 1, _type: 1}, {unique: true, name: 'by_id'})

        has_many :logs, as: :logger, class_name: Libis::Workflow::Mongoid::LogEntry.to_s,
                 dependent: :destroy, autosave: true do
          def log_history
            where(:status.exists => false).order(c_at: 1)
          end

          def status_log(task = nil)
            if task
              where(:status.exists => true, task: task)
            else
              where(:status.exists => true)
            end.order(c_at: 1)
          end

          def get_status(task = nil)
            if task
              where(:status.exists => true, task: task)
            else
              where(:status.exists => true)
            end.order(c_at: -1).limit(1).first
          end
        end

        has_many :items, as: :parent, class_name: Libis::Workflow::Mongoid::WorkItem.to_s,
                 dependent: :destroy, autosave: true, order: :c_at.asc

        belongs_to :parent, polymorphic: true

        index({parent_id: 1, parent_type: 1, c_at: 1}, {name: 'by_parent'})

        set_callback(:destroy, :before) do |document|
          # noinspection RubyResolve
          document.logs.each { |log| log.destroy! }
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

        # Get last known status entry for a given task
        #
        # In the Mongid storage, we retrieve the status log in date descending order, so we retrieve the first item.
        # @param [String] task task name to check item status for
        # @return [Hash] the status entry
        def status_entry(task = nil)
          self.logs.get_status(task)
        end

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
