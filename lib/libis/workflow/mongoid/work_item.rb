# encoding: utf-8
require 'LIBIS_Workflow'
require 'libis/workflow/mongoid/base_model'

module LIBIS
  module Workflow
    module Mongoid
      class WorkItem
        include LIBIS::Workflow::WorkItem
        include BaseModel

        belongs_to :parent, class_name: 'LIBIS::Workflow::Mongoid::WorkItemModel', inverse_of: :items, dependent: :nullify
        has_many :items, class_name: 'LIBIS::Workflow::Mongoid::WorkItemModel', inverse_of: :parent, autosave: true, dependent: :destroy

        field :options, type: Hash, default: -> { Hash.new }
        field :properties, type: Hash, default: -> { Hash.new }

        field :log_history, type: Array, default: -> { Array.new }
        field :status_log, type: Array, default: -> { Array.new }

        field :summary, type: Hash, default: -> { Hash.new }

        def name
          self.options[:name]
        end

        def item_count
          self.items.length
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
