# encoding: utf-8

require 'libis/workflow/base/workflow'
require 'libis/workflow/mongoid/base'
require 'libis/tools/config_file'
require 'libis/tools/extend/hash'

module Libis
  module Workflow
    module Mongoid

      module Workflow

        def self.included(klass)
          klass.class_eval do
            include ::Libis::Workflow::Base::Workflow
            include ::Libis::Workflow::Mongoid::Base

            store_in collection: 'workflow_definitions'

            field :name, type: String
            field :description, type: String
            field :config, type: Hash, default: -> { Hash.new }

            index({name: 1}, {unique: 1})

            def klass.job_class(job_klass)
              has_many :jobs, inverse_of: :workflow, class_name: job_klass.to_s,
                       dependent: :destroy, autosave: true, order: :c_at.asc
            end

            def klass.load(file_or_hash)
              config = Libis::Tools::ConfigFile.new
              config << file_or_hash
              return nil if config.empty?
              workflow = self.new
              workflow.configure(config.to_hash.key_strings_to_symbols(recursive: true))
              workflow
            end

          end

        end

      end
    end
  end
end
