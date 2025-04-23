# frozen_string_literal: true

require "dry/core"
require "initable"
require "refinements/hash"

module Terminus
  module Aspects
    module API
      module Transformers
        # Transforms raw firmware log into attributes fit for creating a device log record.
        class FirmwareLog
          include Initable[
            key_map: {
              additional_info_retry_attempt: :retry,
              creation_timestamp: :created_at,
              device_status_stamp_battery_voltage: :battery_voltage,
              device_status_stamp_current_fw_version: :firmware_version,
              device_status_stamp_free_heap_size: :free_heap_size,
              device_status_stamp_max_alloc_size: :max_alloc_size,
              device_status_stamp_refresh_rate: :refresh_rate,
              device_status_stamp_special_function: :special_function,
              device_status_stamp_time_since_last_sleep_start: :sleep_duration,
              device_status_stamp_wakeup_reason: :wake_reason,
              device_status_stamp_wifi_rssi_level: :wifi_signal,
              device_status_stamp_wifi_status: :wifi_status,
              log_codeline: :source_line,
              log_id: :external_id,
              log_message: :message,
              log_sourcefile: :source_path
            }.freeze
          ]

          using Refinements::Hash

          def call payload
            payload.fetch(:log, Dry::Core::EMPTY_HASH)
                   .fetch(:logs_array, Dry::Core::EMPTY_ARRAY)
                   .map do |item|
                     item.flatten_keys
                         .transform_keys!(key_map)
                         .transform_value!(:created_at) { Time.at it }
                   end
          end
        end
      end
    end
  end
end
