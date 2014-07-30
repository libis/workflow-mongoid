# encoding: utf-8
require 'mongoid/document'
require 'mongoid_indifferent_access'

module LIBIS
  module Workflow
    module Mongoid
      class WorkItem < LIBIS::Workflow::WorkItem
        include ::Mongoid::Document
        include ::Mongoid::Timestamps
        include ::Mongoid::Extensions::Hash::IndifferentAccess

        field :status, type: Symbol, default: :START
        field :options, type: Hash, default: -> { Hash.new }
        field :properties, type: Hash, default: -> { Hash.new }
        field :log_history, type: Array, default: -> { Array.new }
        field :status_log, type: Array, default: -> { Array.new }
        field :summary, type: Hash, default: -> { Hash.new }

        has_many :items, class_name: 'LIBIS::Workflow::Mongoid::WorkItemModel', inverse_of: :parent, autosave: true, dependent: :destroy
        belongs_to :parent, class_name: 'LIBIS::Workflow::Mongoid::WorkItemModel', inverse_of: :items, dependent: :nullify

        index status: 1

        def name
          self.to_string
        end

        def item_count
          self.items.length
        end

        def to_string
          self.options[:name]
        end

        def <<(item)
          return self unless item
          self.items << item
          self.save!
          item.save!
          self
        end

        def each
          (0...self.items.count).each do |i|
            yield self.items[i]
          end
        end

      end
    end
  end
end
