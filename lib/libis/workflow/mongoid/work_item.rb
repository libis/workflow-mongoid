# encoding: utf-8
require 'libis-workflow'
require_relative 'dynamic'

module Libis
  module Workflow
    module Mongoid

      class WorkItem

        include Libis::Workflow::Base::WorkItem
        include Libis::Workflow::Mongoid::WorkItemBase

      end

    end
  end
end
