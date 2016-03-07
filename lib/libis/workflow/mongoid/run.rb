# encoding: utf-8
require 'fileutils'

require 'libis/workflow/base/run'
require 'libis/workflow/mongoid/work_item_base'

module Libis
  module Workflow
    module Mongoid

      class Run

        include ::Libis::Workflow::Base::Run
        include ::Libis::Workflow::Mongoid::WorkItemBase
        # extend ActiveSupport::Concern

        store_in collection: 'workflow_runs'

        field :start_date, type: Time, default: -> { Time.now }
        field :log_to_file, type: Boolean, default: false

        set_callback(:destroy, :before) do |document|
          wd = document.work_dir
          FileUtils.rmtree wd if wd && !wd.blank? && Dir.exist?(wd)
        end

        index start_date: 1

        belongs_to :job, polymorphic: true
        embeds_one :log_config, as: :log_configurator

        def run
          self.tasks = []
          self.items = []
          # noinspection RubySuperCallWithoutSuperclassInspection
          super
        end

        def logger
          return ::Libis::Workflow::Mongoid::Config.logger unless self.log_to_file
          logger = ::Logging::Repository[self.name]
          return logger if logger
          unless ::Logging::Appenders[self.name]
            ::Logging::Appenders::File.new(
                self.name,
                filename: File.join(::Libis::Workflow::Mongoid::Config[:log_dir], "#{self.name}.log"),
                layout: Config.get_log_formatter,
                level: self.log_level
            )
          end
          logger = Config.logger(self.name, self.name)
          logger.additive = false
          logger
        end

      end

    end
  end
end
