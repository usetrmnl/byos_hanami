# auto_register: false
# frozen_string_literal: true

module Terminus
  module Serializers
    # A device serializer for specific keys.
    class Device
      KEYS = %i[
        id
        model_id
        playlist_id
        friendly_id
        label
        mac_address
        api_key
        firmware_version
        wifi
        battery
        refresh_rate
        image_timeout
        width
        height
        proxy
        firmware_update
        sleep_start_at
        sleep_stop_at
        created_at
        updated_at
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
