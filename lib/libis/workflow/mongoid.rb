# encoding: utf-8

require 'libis-workflow'

require_relative 'mongoid/version'

module Libis
  module Workflow
    module Mongoid

      autoload :Config, 'libis/workflow/mongoid/config'
      autoload :Base, 'libis/workflow/mongoid/base'
      autoload :Workflow, 'libis/workflow/mongoid/workflow'
      autoload :WorkItem, 'libis/workflow/mongoid/work_item'
      autoload :Run, 'libis/workflow/mongoid/run'
      autoload :Worker, 'libis/workflow/mongoid/worker'

      def self.configure
        yield ::Libis::Workflow::Mongoid::Config.instance
      end

    end

  end
end
