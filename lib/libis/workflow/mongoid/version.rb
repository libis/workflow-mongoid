module Libis
  module Workflow
    module Mongoid
      VERSION = '2.1.1' unless const_defined? :VERSION # the guard is against a redefinition warning that happens on Travis
    end
  end
end
