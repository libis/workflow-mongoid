# encoding: utf-8
require 'libis-workflow'
require 'libis/workflow/mongoid/base'

require 'mongoid/extensions/time_with_zone'

module Libis
  module Workflow
    module Mongoid

      class LogEntry
        include Libis::Workflow::Mongoid::Base

        store_in collection: 'log'

        field :severity, type: String
        field :task, type: String, default: '*UNKNOWN*'
        field :code, type: Integer
        field :message, type: String
        field :status, type: String

        belongs_to :logger, polymorphic: true

      end

    end
  end
end
