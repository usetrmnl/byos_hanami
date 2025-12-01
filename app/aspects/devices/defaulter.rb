# frozen_string_literal: true

require "initable"
require "securerandom"

module Terminus
  module Aspects
    module Devices
      # Builds default attributes for new devices.
      class Defaulter
        include Initable[randomizer: SecureRandom]

        def call
          {
            api_key: randomizer.alphanumeric(20),
            firmware_update: true,
            friendly_id: randomizer.hex(3).upcase,
            image_timeout: 0,
            label: "TRMNL",
            refresh_rate: 900
          }
        end
      end
    end
  end
end
