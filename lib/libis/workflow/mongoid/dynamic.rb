require 'mongoid'
require 'mongoid/document'
require 'libis/workflow/mongoid/sequence'

module Libis
  module Workflow
    module Mongoid
      module Dynamic

        module ClassMethods
          def has_key?(key)
            self.attributes.has_key?(key.to_s) || self.attributes.has_key?(key.to_sym)
          end

          def each(&block)
            self.attributes.reject { |k,_| k == '_id' }.each(&block)
          end
        end

        def self.included(klass)
          klass.extend(ClassMethods)

          klass.class_eval do

            include ::Mongoid::Document
            include ::Mongoid::Attributes::Dynamic
            include ::Libis::Workflow::Mongoid::Sequence

            field :_id, type: Integer, overwrite: true
            sequence :_id
            index _id: 1

          end
        end

      end
    end
  end
end
