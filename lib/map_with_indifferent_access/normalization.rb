require "map_with_indifferent_access/normalization/deep_normalizer"

module MapWithIndifferentAccess
  module Normalization
    class << self
      # Deeply normalizes `Hash`-like and `Array`-like hash entry
      # values and array items, preserving all of the existing key
      # values (`String`, `Symbol`, or otherwise) from the inner
      # collections.
      #
      # @see DeepNormalizer#call
      def deeply_normalize(obj)
        deep_basic_normalizer.call( obj )
      end

      # Deeply coerces keys to `Symbol` type.
      #
      # @see DeepNormalizer#call
      def deeply_symbolize_keys(obj)
        deep_key_symbolizer.call( obj )
      end

      # Deeply coerces keys to `String` type.
      #
      # @see DeepNormalizer#call
      def deeply_stringify_keys(obj)
        deep_key_stringifier.call( obj )
      end

      private

      def deep_basic_normalizer
        @deep_basic_normalizer ||= DeepNormalizer.new( NullKeyStrategy )
      end

      def deep_key_symbolizer
        @deep_key_symbolizer ||= DeepNormalizer.new( SymbolizationKeyStrategy )
      end

      def deep_key_stringifier
        @deep_key_stringifier ||= DeepNormalizer.new( StringificationKeyStrategy )
      end
    end

    module KeyStrategy
      def self.needs_coercion?(key)
        raise NotImplementedError, "Including-module responsibility"
      end

      def self.coerce(key)
        raise NotImplementedError, "Including-module responsibility"
      end
    end

    module NullKeyStrategy
      extend Normalization::KeyStrategy

      def self.needs_coercion?(key)
        false
      end

      def self.coerce(key)
        key
      end
    end

    module SymbolizationKeyStrategy
      extend Normalization::KeyStrategy

      def self.needs_coercion?(key)
        !( Symbol === key )
      end

      def self.coerce(key)
        key.to_s.to_sym
      end
    end

    module StringificationKeyStrategy
      extend Normalization::KeyStrategy

      def self.needs_coercion?(key)
        !( String === key )
      end

      def self.coerce(key)
        key.to_s
      end
    end

  end
end
