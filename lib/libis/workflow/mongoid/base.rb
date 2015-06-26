# encoding: utf-8
require 'mongoid'
require 'mongoid/document'
require 'mongoid_indifferent_access'
require_relative 'sequence'

module Libis
  module Workflow
    module Mongoid

      module Base

        def self.included(klass)
          klass.class_eval do
            include ::Mongoid::Document
            include ::Mongoid::Timestamps
            include ::Mongoid::Extensions::Hash::IndifferentAccess
            include ::Libis::Workflow::Mongoid::Sequence
            field :_id, type: Integer
            sequence :_id
            index created_at: 1
          end
        end

      end

    end
  end
end
