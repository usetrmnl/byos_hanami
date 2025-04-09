# frozen_string_literal: true

require "dry/core"

module Terminus
  module Structs
    # The device struct.
    class Device < DB::Struct
      def as_api_display
        {image_url_timeout: image_timeout, refresh_rate:, update_firmware: firmware_update}
      end

      def slug = mac_address.tr ":", Dry::Core::EMPTY_STRING
    end
  end
end
