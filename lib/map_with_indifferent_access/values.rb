module MapWithIndifferentAccess

  module Values

    class << self
      # Converts `obj` to a {Map} or {List} if possible, otherwise
      # returns `obj`.
      #
      # @return [Map, List, Object]
      def externalize(obj)
        (
          Map.try_convert( obj ) ||
          List.try_convert( obj ) ||
          obj
        )
      end

      alias >> externalize

      # Converts `obj`, which might be a {Map} or {List} to a
      # `Hash` or `Array` if possible.  Returns `obj` if no
      # conversion is possible.
      #
      # @return [Hash, Array, Object]
      def internalize(obj)
        (
          Map.try_deconstruct( obj ) ||
          List.try_deconstruct( obj ) ||
          obj
        )
      end

      alias << internalize
    end

  end

end

