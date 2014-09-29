# encoding: utf-8
require 'mongoid'
require 'mongoid/document'
require 'mongoid_indifferent_access'

module LIBIS
  module Workflow
    module Mongoid

      module Base

        def self.included(klass)
          klass.class_eval do
            include ::Mongoid::Document
            include ::Mongoid::Timestamps
            include ::Mongoid::Extensions::Hash::IndifferentAccess
            index created_at: 1
          end
        end

      end

    end
  end
end
