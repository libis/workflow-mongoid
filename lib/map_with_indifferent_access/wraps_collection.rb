require 'forwardable'

module MapWithIndifferentAccess

  module WrapsCollection
    extend Forwardable
    include Enumerable

    # The encapsulated collection object.
    attr_reader :inner_collection

    # @!method length
    #   The number of entries in the collection.
    #
    #   @return [Fixnum]
    #   @see #size

    # @!method size
    #   The number of entries in the collection.
    #
    #   @return [Fixnum]
    #   @see #length

    # @!method empty?
    #   Returns `true` if the collection contains no entries.
    #
    #   Returns `false` if the collection contains 1 or more
    #   entries.
    #
    #   @return [Boolean]

    # @!method _frozen?
    #   Returns true when the target object (the wrapper) is
    #   frozen.
    #
    #   There are some cases in which this returns `false` when
    #   {#frozen?} would return `true`.
    #
    #   @return [Boolean]
    #   @see #frozen?

    # Using `class_eval` to hide the aliasing from YARD, so it
    # does not document this alias to the implementation
    # inherited from `Object` as an alias to the subsequent
    # override.
    class_eval 'alias _frozen? frozen?', __FILE__, __LINE__

    # @!method tainted?
    #   Reflects the tainted-ness of its #inner_collection.
    #   @return [Boolean]

    # @!method untrusted?
    #   Reflects the untrusted-ness of its #inner_collection.
    #   @return [Boolean]

    # @!method frozen?
    #   Reflects the frozen-ness of its {#inner_collection}.
    #
    #   Returns `true` when the {#inner_collection} is frozen (
    #   and the target/wrapper might be frozen or not).
    #
    #   Returns `false` when the {#inner_collection} is not
    #   frozen (and neither is the target/wrapper).
    #
    #   When the {#inner_collection} is frozen, but the target
    #   object is not, then the target behaves as if frozen in
    #   most ways, but some of the restrictions that Ruby applies
    #   to truly frozen (such as preventing instance methods from
    #   being dynamically added to the object) do not apply.
    #
    #   @return [Boolean]
    #   @see #_frozen?

    # @!method hash
    #   Compute a hash-code for this collection wrapper. Two
    #   wrappers with the same type and the same
    #   {#inner_collection} content will have the same hash code
    #   (and will match using {#eql?}).
    #
    #   @return [Fixnum]

    def_delegators(
      :inner_collection,
      :length,
      :size,
      :empty?,
      :tainted?,
      :untrusted?,
      :frozen?,
      :hash,
    )

    # @!method taint
    # Causes the target's #inner_collection to be tainted.

    # @!method untaint
    # Causes the target's #inner_collection to be untainted.

    # @!method untrust
    # Causes the target's #inner_collection to be untrusted.

    # @!method trust
    # Causes the target's {#inner_collection} to be trusted.

    [:taint, :untaint, :untrust, :trust ].each do |method_name|
      class_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{method_name}
          inner_collection.#{method_name}
          self
        end
      EOS
    end

    # Removes all entries from the target's {#inner_collection}.
    def clear
      inner_collection.clear
      self
    end

    # Freezes both the target map and its {#inner_collection}
    # object.
    def freeze
      super
      inner_collection.freeze
      self
    end

    # Returns `true` for another instance of the same class as
    # the target where the target's {#inner_collection} is
    # `#eql?` to the given object's {#inner_collection}. Returns
    # `false` otherwise.
    #
    # @return [Boolean]
    def eql?(other)
      self.class == other.class &&
        self.inner_collection.eql?( other.inner_collection )
    end

    private

    def initialize_dup(orig)
      super
      @inner_collection = inner_collection.dup
    end

    def initialize_clone(orig)
      super
      @inner_collection = inner_collection.clone
    end
  end

end
