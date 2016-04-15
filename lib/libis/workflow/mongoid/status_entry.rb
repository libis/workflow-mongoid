require 'libis-workflow'
require 'libis/workflow/mongoid/base'

require 'mongoid/extensions/time_with_zone'

module Libis
  module Workflow
    module Mongoid

      class StatusEntry
        include ::Mongoid::Document
        include ::Mongoid::Timestamps::Short

        field :task, type: String
        field :status, type: String, default: 'STARTED'
        field :progress, type: Integer
        field :max, type: Integer

        index({c_at: 1}, {name: 'by_created'})
        index({u_at: 1}, {name: 'by_updated'})

        embedded_in :item, polymorphic: true
      end

    end
  end
end
