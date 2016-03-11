require 'libis-workflow'

require_relative 'mongoid/version'

module Libis
  module Workflow
    module Mongoid

      autoload :Base, 'libis/workflow/mongoid/base'
      autoload :Config, 'libis/workflow/mongoid/config'
      autoload :LogEntry, 'libis/workflow/mongoid/log_entry'
      autoload :Job, 'libis/workflow/mongoid/job'
      autoload :WorkItem, 'libis/workflow/mongoid/work_item'
      autoload :Run, 'libis/workflow/mongoid/run'
      autoload :Worker, 'libis/workflow/mongoid/worker'
      autoload :Workflow, 'libis/workflow/mongoid/workflow'

      def self.configure
        yield ::Libis::Workflow::Mongoid::Config.instance
      end

    end

  end
end
