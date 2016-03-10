require "map_with_indifferent_access/version"
require "map_with_indifferent_access/wraps_collection"
require "map_with_indifferent_access/map"
require "map_with_indifferent_access/list"
require "map_with_indifferent_access/values"
require "map_with_indifferent_access/normalization"
require 'forwardable'

module MapWithIndifferentAccess
  class << self
    extend Forwardable

    # @!method new
    #   Creates and returns a new instance of {Map}.
    #
    #   @return [Map]
    #   @see Map#initialize
    def_delegator Map, :new
  end
end
