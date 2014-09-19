# coding: utf-8
require_relative 'file_item'

module LIBIS
  module Workflow
    module Mongoid

      class DirItem < LIBIS::Workflow::Mongoid::FileItem
        include LIBIS::Workflow::DirItem
      end

    end
  end
end
