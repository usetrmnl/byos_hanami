# frozen_string_literal: true

require "initable"
require "securerandom"

module Terminus
  module Actions
    module API
      module Setup
        # The show action.
        class Show < Terminus::Action
          include Deps[repository: "repositories.device"]
          include Initable[randomizer: SecureRandom, model: Aspects::API::Responses::Setup]

          format :json

          def handle request, response
            mac_address, firmware_version = request.env.values_at "HTTP_ID", "HTTP_FW_VERSION"
            device = repository.find_by_mac_address mac_address
            device ||= create_device mac_address, firmware_version
            response.body = model.for(device).to_json
          end

          private

          def create_device mac_address, firmware_version
            repository.create label: "TRMNL",
                              friendly_id: generate_friendly_id,
                              mac_address:,
                              api_key: generate_api_key,
                              firmware_version:,
                              setup_at: Time.now
          end

          def generate_friendly_id = randomizer.hex(3).upcase

          def generate_api_key = randomizer.alphanumeric 20
        end
      end
    end
  end
end
