# frozen_string_literal: true

module Terminus
  module HTTP
    module Headers
      KEY_MAP = {
        HTTP_ACCESS_TOKEN: :access_token,
        HTTP_BATTERY_VOLTAGE: :battery_voltage,
        HTTP_FW_VERSION: :firmware_version,
        HTTP_HOST: :host,
        HTTP_ID: :mac_address,
        HTTP_REFRESH_RATE: :refresh_rate,
        HTTP_RSSI: :rssi,
        HTTP_USER_AGENT: :user_agent,
        HTTP_WIDTH: :width,
        HTTP_HEIGHT: :height
      }.freeze

      # Models the HTTP headers for quick access of attributes.
      Model = Data.define(*KEY_MAP.values) do
        def self.for(headers, key_map: KEY_MAP) = new(**headers.transform_keys(key_map))

        def device_attributes = {battery_voltage:, firmware_version: firmware_version.to_s, rssi:}
      end
    end
  end
end
