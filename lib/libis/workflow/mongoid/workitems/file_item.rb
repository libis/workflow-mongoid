# coding: utf-8
require_relative 'work_item'

module LIBIS
  module Workflow
    module Mongoid

      class FileItem < ::LIBIS::Workflow::Mongoid::WorkItem
        include LIBIS::Workflow::FileItem
      end

    end
  end
end
