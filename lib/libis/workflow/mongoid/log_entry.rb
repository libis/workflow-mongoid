require 'libis-workflow'
require 'libis/workflow/mongoid/base'

require 'mongoid/extensions/time_with_zone'

module Libis
  module Workflow
    module Mongoid

      class LogEntry
        include ::Mongoid::Document
        include ::Mongoid::Timestamps::Created::Short

        store_in collection: 'log'

        field :severity, type: String
        field :task, type: String, default: ''
        field :code, type: Integer
        field :message, type: String
        field :run_id

        index({c_at: 1}, {name: 'by_created'})
        index({logger_type: 1, logger_id: 1, c_at: 1, }, {background: true, name: 'by_logger'})
        index({logger_type: 1, logger_id: 1, c_at: 1, task: 1}, {background: true, name: 'by_task'})

        belongs_to :logger, polymorphic: true

      end

    end
  end
end
