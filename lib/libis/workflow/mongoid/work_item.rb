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
        field :status_log, type: Array, default: -> { Array.new }

        index({_id: 1, _type: 1}, {unique: true, name: 'by_id'})

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
