# encoding: utf-8
require 'singleton'
require 'mongoid'

require 'libis/workflow/config'
require 'libis/workflow/mongoid/run'

module Libis
  module Workflow
    module Mongoid

     class Config
       include Singleton

       def database_connect(config_file = './mongoid.yml', environment = nil)
         ::Mongoid.load! config_file, environment
       end

       def method_missing(name, *args, &block)
         ::Libis::Workflow::Config.instance.send(name, *args, &block)
       end

       def self.const_missing(name)
         return ::Libis::Workflow::Config.const_get(name) if ::Libis::Workflow::Config.const_defined?(name)
         super(name)
       end

       private

       def initialize
         ::Libis::Workflow::Config.instance
       end
      end
    end
  end
end
