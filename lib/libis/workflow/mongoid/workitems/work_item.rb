# encoding: utf-8
require 'libis/workflow/mongoid/workitems/work_item_base'

module LIBIS
  module Workflow
    module Mongoid

      class WorkItem
        include LIBIS::Workflow::Mongoid::WorkItemBase

        store_in collection: 'workflow_items'

        # embeds_many :items, class_name: 'LIBIS::Workflow::Mongoid::WorkItem', cyclic: true
        # embedded_in :parent, class_name: 'LIBIS::Workflow::Mongoid::WorkItem', cyclic: true

        has_many :items, class_name: 'LIBIS::Workflow::Mongoid::WorkItem', inverse_of: :parent,
                 dependent: :destroy, autosave: true, order: :created_at.asc
        belongs_to :parent, class_name: 'LIBIS::Workflow::Mongoid::WorkItem', inverse_of: :items

        belongs_to :run, class_name: 'LIBIS::Workflow::Mongoid::Run', inverse_of: :items

        def parent
          self[:parent] || self[:run]
        end

      end

    end
  end
end
