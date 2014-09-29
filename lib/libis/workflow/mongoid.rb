# encoding: utf-8

require 'LIBIS_Workflow'

module LIBIS
  module Workflow
    module Mongoid

      autoload :Config, 'libis/workflow/mongoid/config'
      autoload :Base, 'libis/workflow/mongoid/base'
      autoload :Workflow, 'libis/workflow/mongoid/workflow'
      autoload :WorkItem, 'libis/workflow/mongoid/work_item'
      autoload :Run, 'libis/workflow/mongoid/run'
      autoload :Worker, 'libis/workflow/mongoid/worker'

      def self.configure
        yield ::LIBIS::Workflow::Mongoid::Config.instance
      end

    end

  end
end
