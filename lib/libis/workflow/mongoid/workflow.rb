require 'libis/workflow/base/workflow'
require 'libis/workflow/mongoid/base'
require 'libis/tools/config_file'
require 'libis/tools/extend/hash'

module Libis
  module Workflow
    module Mongoid

      class Workflow

        include ::Libis::Workflow::Base::Workflow
        include ::Libis::Workflow::Mongoid::Base

        store_in collection: 'workflow_definitions'

        field :name, type: String
        field :description, type: String
        field :config, type: Hash, default: -> { Hash.new }

        index({name: 1}, {unique: 1, name: 'by_name'})

        has_many :jobs, as: :workflow, dependent: :restrict, autosave: true, order: :name.asc

        def self.from_hash(hash)
          self.create_from_hash(hash, [:name]) do |item, cfg|
            item.configure(cfg.merge('name' => item.name))
            cfg.clear
          end
        end

        def self.load(file_or_hash)
          config = Libis::Tools::ConfigFile.new
          config << file_or_hash
          return nil if config.empty?
          workflow = self.new
          workflow.configure(config.to_hash.key_symbols_to_strings(recursive: true))
          workflow
        end

      end
    end
  end
end
