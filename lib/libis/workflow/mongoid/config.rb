# encoding: utf-8
require 'singleton'
require 'mongoid'

require 'libis/workflow/config'
require 'libis/workflow/mongoid/run'

module Libis
  module Workflow
    module Mongoid

     class Config < ::Libis::Workflow::Config

       def self.database_connect(config_file = './mongoid.yml', environment = nil)
         ::Mongoid.load! config_file, environment
       end

      end
    end
  end
end
