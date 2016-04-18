require 'libis-workflow'
require 'libis/workflow/mongoid/base'

require 'mongoid/extensions/time_with_zone'

module Libis
  module Workflow
    module Mongoid

      class StatusEntry
        include ::Mongoid::Document

        field :task, type: String
        field :created, type: DateTime, default: -> { DateTime.now }
        field :updated, type: DateTime
        field :status, type: String, default: 'STARTED'
        field :progress, type: Integer
        field :max, type: Integer

        index({created: 1}, {name: 'by_created'})
        index({updated: 1}, {name: 'by_updated'})

        embedded_in :item, polymorphic: true
      end

    end
  end
end
