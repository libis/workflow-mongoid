# encoding: utf-8
require 'libis/workflow/mongoid/work_item_base'

module Libis
  module Workflow
    module Mongoid

      module WorkItem

        def self.included(klass)
          klass.class_eval do
            include Libis::Workflow::Mongoid::WorkItemBase

            store_in collection: 'workflow_items'

            item_class klass

          end
        end

      end

    end
  end
end
