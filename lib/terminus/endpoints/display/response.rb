# frozen_string_literal: true

module Terminus
  module Endpoints
    module Display
      # Models data for API display responses.
      Response = Struct.new(
        :filename,
        :firmware_url,
        :image_url,
        :image_url_timeout,
        :refresh_rate,
        :reset_firmware,
        :special_function,
        :update_firmware
      ) do
        def self.for(attributes) = new(**attributes)

        def initialize(**)
          super
          apply_defaults
          freeze
        end

        def to_json(*) = to_h.to_json(*)

        private

        def apply_defaults
          self[:image_url_timeout] ||= 0
          self[:refresh_rate] ||= 300
          self[:reset_firmware] ||= false
          self[:update_firmware] ||= false
          self[:special_function] ||= "sleep"
        end
      end
    end
  end
end
