# encoding: utf-8
require 'libis/workflow/mongoid/base_model'

module LIBIS
  module Workflow
    module Mongoid

      class WorkflowInput
        include BaseModel

        field :name, type: String
        field :description, type: String
        field :option_key, type: String
        field :type, type: String
        field :default

        embedded_in :workflow, class_name: 'LIBIS::Workflow::Mongoid::WorkflowDefinition'

        def config
          {
              name: self[:name],
              description: self[:description],
              option_key: self[:option_key],
              type: self[:type],
              default: self[:default]
          }.delete_if { |_,v| (v.nil? || (v.respond_to?(:empty?) && v.empty?)) rescue false }

        end

      end

    end
  end
end