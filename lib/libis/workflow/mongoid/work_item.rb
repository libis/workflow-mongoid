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
        field :status_log, type: Array, default: -> { Array.new }

        index({_id: 1, _type: 1}, {unique: true, name: 'by_id'})

        has_many :items, as: :parent, class_name: Libis::Workflow::Mongoid::WorkItem.to_s,
                 dependent: :destroy, autosave: true, order: :c_at.asc

        belongs_to :parent, polymorphic: true

        index({parent_id: 1, parent_type: 1, c_at: 1}, {name: 'by_parent'})

        def add_item(item)
          raise Libis::WorkflowError, 'Trying to add item already linked to another item' unless item.parent.nil?
          super(item)
        end

        def copy_item(item)
          new_item = item.dup
          yield new_item, item if block_given?
          new_item.parent = nil
          item.get_items.each { |i| new_item.copy_item(i) }
          self.add_item(new_item)
          new_item
        end

        def move_item(item)
          new_item = item.dup
          yield new_item, item if block_given?
          new_item.parent = nil
          item.get_items.each { |i| new_item.move_item(i) }
          self.add_item(new_item)
          if item.parent
            item.parent.items.delete(item)
          end
          new_item
        end

        def get_items
          self.items.no_timeout
        end

        def get_item_list
          self.items.to_a
        end

        protected

        def add_status_log(info)
          # noinspection RubyResolve
          self.status_log << info
          self.status_log.last
        end

      end

    end
  end
end
