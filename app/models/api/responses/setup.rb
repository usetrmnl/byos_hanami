# auto_register: false
# frozen_string_literal: true

module Terminus
  module Models
    module API
      module Responses
        # Models data for API setup responses.
        Setup = Struct.new :api_key, :friendly_id, :image_url, :message, :status do
          def self.for device
            new api_key: device.api_key,
                friendly_id: device.friendly_id,
                image_url: %(#{Hanami.app[:settings].api_uri}/images/setup/logo.bmp),
                message: "Welcome to TRMNL BYOS",
                status: 200
          end

          def initialize **arguments
            super

            self[:message] ||= "MAC Address not registered."
            self[:status] ||= 404

            freeze
          end

          def to_json(*) = to_h.to_json(*)
        end
      end
    end
  end
end
