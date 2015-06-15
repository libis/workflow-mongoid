# encoding: utf-8
require 'singleton'
require 'mongoid'

require 'libis/workflow/config'
require 'libis/workflow/mongoid/run'

module Libis
  module Workflow
    module Mongoid

      # noinspection RubyConstantNamingConvention
      Config = ::Libis::Workflow::Config

      Config.define_singleton_method(:database_connect) do |config_file = './mongoid.yml', environment = nil|
        # noinspection RubyResolve
        instance.database_connect(config_file, environment)
      end

      Config.send(:define_method, :database_connect) do |config_file = './mongoid.yml', environment = nil|
        ::Mongoid.load! config_file, environment
      end

    end
  end
end
