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

        set_callback(:destroy, :before) do |document|
          wd = document.work_dir
          FileUtils.rmtree wd if wd && !wd.blank? && Dir.exist?(wd)
        end

        index start_date: 1

        belongs_to :job, polymorphic: true
        embeds_one :log_config

        def run
          self.tasks = []
          self.items = []
          # noinspection RubySuperCallWithoutSuperclassInspection
          super
        end

        def logger
          self.log_config.logger("#{self.name}.log") || ::Libis::Workflow::Mongoid::Config.logger
        end

      end

    end
  end
end
