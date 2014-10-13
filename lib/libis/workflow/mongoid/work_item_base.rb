# encoding: utf-8
require 'LIBIS_Workflow'
require 'libis/workflow/mongoid/base'

module LIBIS
  module Workflow
    module Mongoid

      module WorkItemBase

        def self.included(klass)
          klass.class_eval do
            include LIBIS::Workflow::WorkItem
            include LIBIS::Workflow::Mongoid::Base

            field :options, type: Hash, default: -> { Hash.new }
            field :properties, type: Hash, default: -> { Hash.new }

            field :log_history, type: Array, default: -> { Array.new }
            field :status_log, type: Array, default: -> { Array.new }

            field :summary, type: Hash, default: -> { Hash.new }
          end

        end

        def item_count
          self.items.size
        end

        def add_item(item)
          return self unless item and item.is_a? LIBIS::Workflow::Mongoid::WorkItem
          self.items << item
          self.save!
          self
        end

        alias :<< :add_item

      end

    end
  end
end
