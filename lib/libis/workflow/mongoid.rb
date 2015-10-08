# encoding: utf-8

require 'libis-workflow'

require_relative 'mongoid/version'

module Libis
  module Workflow
    module Mongoid

      autoload :Base, 'libis/workflow/mongoid/base'
      autoload :Config, 'libis/workflow/mongoid/config'
      autoload :LogEntry, 'libis/workflow/mongoid/log_entry'
      autoload :Run, 'libis/workflow/mongoid/run'
      autoload :WorkItem, 'libis/workflow/mongoid/work_item'
      autoload :WorkItemBase, 'libis/workflow/mongoid/work_item_base'
      autoload :Worker, 'libis/workflow/mongoid/worker'
      autoload :Workflow, 'libis/workflow/mongoid/workflow'

      def self.configure
        yield ::Libis::Workflow::Mongoid::Config.instance
      end

    end

  end
end
