# encoding: utf-8

require 'LIBIS_Workflow'

module LIBIS
  module Workflow
    module Mongoid

      autoload :BaseModel, 'libis/workflow/mongoid/base_model'
      autoload :Config, 'libis/workflow/mongoid/config'
      autoload :WorkItem, 'libis/workflow/mongoid/work_item'
      autoload :FileItem, 'libis/workflow/mongoid/file_item'
      autoload :Worker, 'libis/workflow/mongoid/worker'
      autoload :Definition, 'libis/workflow/mongoid/definition'
      autoload :Input, 'libis/workflow/mongoid/input'
      autoload :WorkflowRun, 'libis/workflow/mongoid/workflow_run'
      autoload :Task, 'libis/workflow/mongoid/task'

      def self.configure
        yield Config.instance
      end

    end
  end
end
