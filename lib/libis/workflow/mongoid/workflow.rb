require 'map_with_indifferent_access'
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
        field :_config, type: Hash, default: -> { Hash.new }

        index({name: 1}, {unique: 1})

        has_many :jobs, as: :workflow, dependent: :destroy, autosave: true, order: :c_at.asc

        def self.from_hash(hash)
          self.create_from_hash(hash, [:name]) do |item, cfg|
            if (value = item.read_attribute(:config))
              item.write_attribute(:_config, value)
              item.remove_attribute(:config)
            end
            item.configure(cfg.key_strings_to_symbols(recursive: true).merge(name: item.name))
            cfg.clear
          end
        end

        def self.load(file_or_hash)
          config = Libis::Tools::ConfigFile.new
          config << file_or_hash
          return nil if config.empty?
          workflow = self.new
          workflow.configure(config.to_hash.key_strings_to_symbols(recursive: true))
          workflow
        end

        indifferent_hash :_config, :config

        def to_hash
          result = super
          result[:config] = result.delete(:_config)
          result
        end

        def input
          Libis::Tools::DeepStruct.new(super)
        end

      end
    end
  end
end
