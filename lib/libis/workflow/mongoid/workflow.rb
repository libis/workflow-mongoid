# encoding: utf-8

require 'libis/workflow/base/workflow'
require 'libis/workflow/mongoid/base'
require 'libis/workflow/mongoid/run'

module LIBIS
  module Workflow
    module Mongoid
      class Workflow
        include ::LIBIS::Workflow::Base::Workflow
        include ::LIBIS::Workflow::Mongoid::Base

        store_in collection: 'workflow_defintions'

        field :name, type: String
        field :description, type: String
        field :config, type: Hash, default: -> { Hash.new }

        has_many :workflow_runs, inverse_of: :workflow, class_name: '::LIBIS::Workflow::Mongoid::Run',
                 dependent: :destroy, autosave: true, order: :created_at.asc

        index({name: 1}, {unique: 1})

      end
    end
  end
end
