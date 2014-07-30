# encoding: utf-8
require 'mongoid/document'
require 'mongoid_indifferent_access'

module LIBIS
  module Workflow
    module Mongoid
      class BaseModel
        include ::Mongoid::Document
        include ::Mongoid::Timestamps
        include ::Mongoid::Extensions::Hash::IndifferentAccess
      end
    end
  end
end
