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

        embeds_many :status_log, as: :item, class_name: Libis::Workflow::Mongoid::StatusEntry.to_s

        has_many :items, as: :parent, class_name: Libis::Workflow::Mongoid::WorkItem.to_s,
                 dependent: :destroy, autosave: true, order: :c_at.asc

        belongs_to :parent, polymorphic: true

        index({parent_id: 1, parent_type: 1, c_at: 1}, {name: 'by_parent'})

        def add_item(item)
          if item.parent
            item.parent = nil
          end
          super
        end

        def get_items
          self.items.to_a
        end

        def status_progress(task, progress = 0, max = nil)
          log_entry = status_entry(task)
          log_entry ||= self.status_log.build(task: task)
          log_entry[:progress] = progress
          log_entry[:max] = max if max
        end

        protected

        # Get last known status entry for a given task
        #
        # In the Mongid storage, we retrieve the status log in date descending order, so we retrieve the first item.
        # @param [String] task task name to check item status for
        # @return [Hash] the status entry
        def status_entry(task = nil)
          task.nil? ?
            self.status_log.order_by(u_at: -1).first :
            self.status_log.order_by(u_at: -1).where(task: task).first
        end

        def add_status_log(info)
          self.status_log.build(info)
        end

      end

    end
  end
end
