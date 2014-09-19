# encoding: utf-8
require 'mongoid/document'
require 'mongoid_indifferent_access'

module LIBIS
  module Workflow
    module Mongoid

      module Base
        def self.included(base)
          base.include ::Mongoid::Document
          base.include ::Mongoid::Timestamps
          base.include ::Mongoid::Extensions::Hash::IndifferentAccess
          base.index created_at: 1
        end

      end

    end
  end
end
