# encoding: utf-8

require 'LIBIS_Workflow'

module LIBIS
  module Workflow
    module Mongoid

      autoload :Config, 'libis/workflow/mongoid/config'
      autoload :Workflow, 'libis/workflow/mongoid/workflow'
      autoload :Run, 'libis/workflow/mongoid/run'
      autoload :Worker, 'libis/workflow/mongoid/worker'

      def self.configure
        yield ::LIBIS::Workflow::Mongoid::Config.instance
      end

    end

  end
end
