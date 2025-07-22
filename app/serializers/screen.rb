# auto_register: false
# frozen_string_literal: true

module Terminus
  module Serializers
    # A screen serializer for specific keys.
    class Screen
      KEYS = %i[id model_id label name created_at updated_at].freeze

      def initialize record, keys: KEYS, transformer: Transformers::Time
        @record = record
        @keys = keys
        @transformer = transformer
      end

      def to_h
        attributes = record.to_h.slice(*keys)
        attributes.transform_values!(&transformer)
        attributes.merge! metadata, uri: record.image_uri if record.image_id
        attributes
      end

      private

      attr_reader :record, :keys, :transformer

      def metadata
        record.image_attributes[:metadata].slice :filename, :mime_type, :width, :height, :size
      end
    end
  end
end
