# encoding: utf-8
require 'mongoid'
require 'mongoid/document'
require 'mongoid_indifferent_access'
require_relative 'sequence'

require 'active_support/core_ext/object/deep_dup'

module Libis
  module Workflow
    module Mongoid

      module Base

        def self.included(klass)
          klass.class_eval do
            include ::Mongoid::Document
            include ::Mongoid::Timestamps::Created::Short
            include ::Mongoid::Extensions::Hash::IndifferentAccess
            include ::Libis::Workflow::Mongoid::Sequence
            field :_id, type: Integer, overwrite: true
            sequence :_id
            index c_at: 1
          end
        end

        def dup
          new_obj = self.class.new
          new_obj.copy_attributes(self)
        end

        def info
          self.attributes.deep_dup.reject { |k,v| v.blank? || volatile_attributes.include?(k) }.to_hash
        end

        protected

        def volatile_attributes
          %w'_id c_at'
        end
        private

        def copy_attributes(other)
          self.set(
              other.attributes.reject do |k, _|
                %W(_id c_at).include? k.to_s
              end.each_with_object({}) do |(k, v), h|
                h[k] = v.duplicable? ? v.dup : v
              end
          )
          self
        end

      end

    end
  end
end
