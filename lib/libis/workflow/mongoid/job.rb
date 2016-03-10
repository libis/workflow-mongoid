require 'map_with_indifferent_access'
require 'libis/workflow/base/job'
require 'libis/workflow/mongoid/base'

module Libis
  module Workflow
    module Mongoid

      class Job

        include ::Libis::Workflow::Base::Job
        include ::Libis::Workflow::Mongoid::Base

        store_in collection: 'workflow_jobs'

        field :name, type: String
        field :description, type: String
        field :_input, type: Hash, default: -> { Hash.new }
        field :run_object, type: String
        field :log_to_file, type: Boolean, default: false
        field :log_each_run, type: Boolean, default: false
        field :log_level, type: String, default: 'DEBUG'
        field :log_age, type: String, default: 'daily'
        field :log_keep, type: Integer, default: 5

        index({name: 1}, {unique: 1})

        has_many :runs, as: :job, dependent: :destroy, autosave: true, order: :c_at.asc

        belongs_to :workflow, polymorphic: true

        def self.from_hash(hash)
          self.create_from_hash(hash, [:name]) do |item, cfg|
            item.workflow = Libis::Workflow::Mongoid.from_hash(name: cfg.delete(:workflow))
          end
        end

        # def input
        #   MapWithIndifferentAccess::Map.new(self.read_attribute(:_input))
        # end
        #
        # def input=(hash)
        #   self.write_attribute(:_input, hash)
        #   self.input
        # end

        indifferent_hash :_input, :input

        def to_hash
          result = super
          result[:input] = result.delete(:_input)
          result
        end

        def logger
          return ::Libis::Workflow::Mongoid::Config.logger unless self.log_to_file
          logger = ::Logging::Repository[self.name]
          return logger if logger
          unless ::Logging::Appenders[self.name]
            ::Logging::Appenders::RollingFile.new(
                self.name,
                filename: File.join(::Libis::Workflow::Mongoid::Config[:log_dir], "#{self.name}{.%Y%m%d}.log"),
                layout: ::Libis::Workflow::Mongoid::Config.get_log_formatter,
                truncate: true,
                age: self.log_age,
                keep: self.log_keep,
                roll_by: 'date',
                level: self.log_level
            )
          end
          logger = ::Libis::Workflow::Mongoid::Config.logger(self.name, self.name)
          logger.additive = false
          logger
        end

        # noinspection RubyStringKeysInHashInspection
        def execute(opts = {})
          if self.log_each_run
            opts[:run_config] = {
                'log_to_file=' => true,
                'log_level=' => self.log_level
            }
          end
          super opts
        end

        # def create_run_object
        #   # noinspection RubyResolve
        #   self.runs.build
        # end

      end

    end
  end
end
