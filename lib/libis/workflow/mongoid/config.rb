# encoding: utf-8
require 'singleton'
require 'mongoid'

require 'libis/workflow/config'

module LIBIS
  module Workflow
    module Mongoid

     class Config
       include Singleton

       def database_connect(config_file = './mongoid.yml', environment = nil)
         ::Mongoid.load! config_file, environment
       end

       def method_missing(name, *args, &block)
         ::LIBIS::Workflow::Config.instance.send(name, *args, &block)
       end

       def self.const_missing(name)
         return ::LIBIS::Workflow::Config.const_get(name) if ::LIBIS::Workflow::Config.const_defined?(name)
         super(name)
       end

      end
    end
  end
end
