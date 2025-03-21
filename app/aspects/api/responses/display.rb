# frozen_string_literal: true

module Terminus
  module Aspects
    module API
      module Responses
        # Models data for API display responses.
        Display = Struct.new(
          :filename,
          :firmware_url,
          :image_url,
          :refresh_rate,
          :reset_firmware,
          :special_function,
          :status,
          :update_firmware
        ) do
          def initialize(**)
            super
            apply_defaults
            freeze
          end

          def to_json(*) = to_h.to_json(*)

          private

          def apply_defaults
            self[:refresh_rate] ||= 300
            self[:reset_firmware] ||= false
            self[:update_firmware] ||= false
            self[:special_function] ||= "sleep"
            self[:status] ||= 404
          end
        end
      end
    end
  end
end
