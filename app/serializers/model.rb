# auto_register: false
# frozen_string_literal: true

module Terminus
  module Serializers
    # A model serializer for specific keys.
    class Model
      KEYS = %i[
        id
        name
        label
        description
        mime_type
        colors
        bit_depth
        scale_factor
        rotation
        offset_x
        offset_y
        width
        height
        published_at
      ].freeze

      def initialize record, keys: KEYS, transformer: Transformers::Time
        @record = record
        @keys = keys
        @transformer = transformer
      end

      def to_h
        attributes = record.to_h.slice(*keys)
        attributes.transform_values!(&transformer)
        attributes
      end

      private

      attr_reader :record, :keys, :transformer
    end
  end
end
