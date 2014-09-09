# encoding: utf-8
require 'LIBIS_Workflow'
require 'mongoid'

module LIBIS
  module Workflow
    module Mongoid

      class Config < LIBIS::Workflow::Config

        def initialize
          super

        end

        def database_connect(config_file = './mongoid.yml', environment = nil)
          ::Mongoid.load! config_file, environment
        end

      end

    end
  end
end
