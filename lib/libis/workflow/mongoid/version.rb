# encoding: utf-8

module LIBIS
  module Workflow
    module Mongoid
      VERSION = '2.0.beta.3' unless const_defined? :VERSION # the guard is against a redefinition warning that happens on Travis
    end
  end
end