# frozen_string_literal: true

require "dry/core"

module Terminus
  module Structs
    # The device struct.
    class Device < DB::Struct
      def as_api_display
        {image_url_timeout: image_timeout, refresh_rate:, update_firmware: firmware_update}
      end

      def asleep? now = Time.now
        return false unless sleep_start_at && sleep_stop_at

        (sleep_start_at.to_s..sleep_stop_at.to_s).cover? now.strftime("%H:%M:%S")
      end

      def slug
        return Dry::Core::EMPTY_STRING unless mac_address

        mac_address.tr ":", Dry::Core::EMPTY_STRING
      end

      def system_label(prefix) = "#{prefix} #{friendly_id}"

      def system_name(kind) = "terminus_#{kind}_#{friendly_id.downcase}"

      def system_screen_attributes kind
        {
          model_id:,
          name: system_name(kind),
          label: system_label(kind.capitalize)
        }
      end
    end
  end
end
