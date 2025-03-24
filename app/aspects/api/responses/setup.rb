# frozen_string_literal: true

module Terminus
  module Aspects
    module API
      module Responses
        # Models data for API setup responses.
        Setup = Struct.new :api_key, :friendly_id, :image_url, :message do
          def self.for device
            new api_key: device.api_key,
                friendly_id: device.friendly_id,
                image_url: %(#{Hanami.app[:settings].api_uri}/assets/setup.bmp),
                message: "Welcome to TRMNL BYOS."
          end

          def initialize(**)
            super
            self[:message] ||= "MAC Address not registered."
            freeze
          end

          def to_json(*) = to_h.to_json(*)
        end
      end
    end
  end
end
