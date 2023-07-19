# noinspection RubyResolve
require 'fileutils'

require 'libis/workflow/base/run'

module Libis
  module Workflow
    module Mongoid

      class Run < Libis::Workflow::Mongoid::WorkItem

        include ::Libis::Workflow::Base::Run

        field :start_date, type: Time, default: -> { Time.now }
        field :log_to_file, type: Boolean, default: false
        field :log_level, type: String, default: 'INFO'
        field :log_filename, type: String
        field :run_name, type: String

        index({start_date: 1}, {sparse: 1, name: 'by_start'})

        belongs_to :job, polymorphic: true

        index({job_id: 1, job_type: 1, start_date: 1}, {sparse: 1, name: 'by_job'})

        has_many :items, as: :parent, class_name: Libis::Workflow::Mongoid::WorkItem.to_s,
                 dependent: :destroy, autosave: true, order: :c_at.asc

        set_callback(:destroy, :before) do |document|
          document.rm_workdir
          document.rm_log
        end

        def rm_log
          log_file = self.log_filename
          FileUtils.rm(log_file) if log_file && !log_file.blank? && File.exist?(log_file)
        end

        def rm_workdir
          workdir = self.work_dir
          FileUtils.rmtree workdir if workdir && !workdir.blank? && Dir.exist?(workdir)
        end

        def work_dir
          # noinspection RubyResolve
          dir = File.join(Libis::Workflow::Config.workdir, self.id)
          FileUtils.mkpath dir unless Dir.exist?(dir)
          dir
        end

        def run(action = :run)
          self.start_date = Time.now
          self.tasks = []
          super action
          self.reload
          self.reload_relations
          close_logger
        end

        def logger
          unless self.log_to_file
            return self.job.logger
          end
          logger = ::Logging::Repository.instance[self.name]
          return logger if logger
          unless ::Logging::Appenders[self.name]
            self.log_filename ||= File.join(::Libis::Workflow::Mongoid::Config[:log_dir], "#{self.name}-#{self.id}.log")
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

        def close_logger
          return unless self.log_to_file
          ::Logging::Appenders[self.name].close
          ::Logging::Appenders.remove(self.name)
          ::Logging::Repository.instance.delete(self.name)
        end

        def name
          parts = [self.job.name]
          parts << self.run_name unless self.run_name.blank?
          parts << self.id.generation_time.strftime('%Y%m%d-%H%M%S')
          parts << self.id.to_s[8..-1] if self.run_name.blank?
          parts.join('-')
        rescue
          self.id.to_s
        end

      end

    end
  end
end
