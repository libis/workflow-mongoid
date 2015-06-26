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

            has_many :items, inverse_of: :parent, class_name: klass.to_s,
                     dependent: :destroy, autosave: true, order: :_id.asc
            belongs_to :parent, inverse_of: :items, class_name: klass.to_s

            def klass.run_class(run_klass)
              belongs_to :run, inverse_of: :items, class_name: run_klass.to_s
            end

          end
        end

        def get_parent
          self[:parent] || self[:run]
        end

        def get_run
          self[:run] || self[:parent].get_run
        end

        def get_root
          self[:parent].get_root rescue self
        end

      end

    end
  end
end
