# frozen_string_literal: true

require "initable"
require "securerandom"

module Terminus
  module Actions
    module API
      module Setup
        # The show action.
        class Show < Terminus::Action
          include Deps[
            repository: "repositories.device",
            device_builder: "aspects.devices.builder",
            welcomer: "aspects.screens.welcomer"
          ]

          include Initable[model: Aspects::API::Responses::Setup]

          format :json

          def handle request, response
            mac_address, firmware_version = request.env.values_at "HTTP_ID", "HTTP_FW_VERSION"
            device = repository.find_by_mac_address mac_address
            device ||= create_device mac_address, firmware_version
            welcomer.call device
            response.body = model.for(device).to_json
          end

          private

          def create_device mac_address, firmware_version
            repository.create device_builder.call.merge(mac_address:, firmware_version:)
          end
        end
      end
    end
  end
end
