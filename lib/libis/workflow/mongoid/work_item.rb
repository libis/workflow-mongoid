# encoding: utf-8
require 'libis-workflow'

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
