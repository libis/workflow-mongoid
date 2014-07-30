# coding: utf-8
require_relative 'work_item'

module LIBIS
  module Workflow
    module Mongoid
      class FileItem < WorkItem
        include LIBIS::Workflow::FileItem
      end
    end
  end
end
