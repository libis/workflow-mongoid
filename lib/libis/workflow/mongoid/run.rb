require 'fileutils'

require 'libis/workflow/base/run'

module Libis
  module Workflow
    module Mongoid

      class Run < Libis::Workflow::Mongoid::WorkItem

        include ::Libis::Workflow::Base::Run

        field :start_date, type: Time, default: -> { Time.now }
        field :log_to_file, type: Boolean, default: false
        field :log_level, type: String, default: 'DEBUG'
        field :log_filename, type: String

        set_callback(:destroy, :before) do |document|
          wd = document.work_dir
          FileUtils.rmtree wd if wd && !wd.blank? && Dir.exist?(wd)
          # noinspection RubyResolve
          log_file = document.log_filename
          FileUtils.rm(log_file) if log_file && !log_file.blank? && File.exist?(log_file)
        end

        index start_date: 1

        belongs_to :job, polymorphic: true
        embeds_one :log_config, as: :log_configurator

        def run(action = :run)
          self.tasks = []
          super action
        end

        def logger
          unless self.log_to_file
            return self.job.logger
          end
          logger = ::Logging::Repository.instance[self.name]
          return logger if logger
          unless ::Logging::Appenders[self.name]
            self.log_filename ||= File.join(::Libis::Workflow::Mongoid::Config[:log_dir], "#{self.name}.log")
            ::Logging::Appenders::File.new(
                self.name,
                filename: self.log_filename,
                layout: ::Libis::Workflow::Mongoid::Config.get_log_formatter,
                level: self.log_level
            )
          end
          logger = ::Libis::Workflow::Mongoid::Config.logger(self.name, self.name)
          logger.additive = false
          logger.level = self.log_level
          logger
        end

      end

    end
  end
end
