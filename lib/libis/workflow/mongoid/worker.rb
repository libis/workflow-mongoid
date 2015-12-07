# encoding: utf-8

require 'libis/workflow/worker'

module Libis
  module Workflow
    module Mongoid

      class Worker < Libis::Workflow::Worker

        def get_job(job_config)
          job_name = job_config.delete(:name) if job_config.is_a? Hash
          job_name ||= job_config.to_s
          job = ::Libis::Workflow::Mongoid::Job.find(name: job_name).first
          raise RuntimeError.new "Workflow #{job_name} not found" unless job.is_a? ::Libis::Workflow::Mongoid::Job
          job
        end

      end
    end
  end
end
