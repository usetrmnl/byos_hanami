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
            label: "TRMNL",
            friendly_id: randomizer.hex(3).upcase,
            api_key: randomizer.alphanumeric(20),
            refresh_rate: 900,
            image_timeout: 0
          }
        end
      end
    end
  end
end
