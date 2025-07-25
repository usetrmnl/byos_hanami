# frozen_string_literal: true

require "dry/monads"
require "initable"
require "versionaire"

module Terminus
  module Actions
    module API
      module Setup
        # The show action.
        class Show < Base
          include Deps["aspects.devices.provisioner", model_repository: "repositories.model"]
          include Initable[payload: Aspects::API::Responses::Setup]
          include Dry::Monads[:result]

          using Refines::Actions::Response

          params do
            required(:HTTP_ID).filled Types::MACAddress
            optional(:HTTP_FW_VERSION).maybe Types::String.constrained(format: Versionaire::PATTERN)
          end

          def handle request, response
            environment = request.env
            result = contract.call environment

            if result.success?
              create environment, response
            else
              unprocessable_entity result.errors.to_h, response
            end
          end

          private

          # FIX: Use dynamic lookup once Firmware Issue 199 is resolved.
          def load_model = model_repository.find_by name: "t1"

          def create environment, response
            mac_address, firmware_version = environment.values_at "HTTP_ID", "HTTP_FW_VERSION"

            case provisioner.call(model_id: load_model.id, mac_address:, firmware_version:)
              in Success(device) then response.with body: payload.for(device).to_json, status: 200
              in Failure(error) then unprocessable_entity error, response
            end
          end

          def create_device mac_address, firmware_version
            repository.create device_defaulter.call.merge(mac_address:, firmware_version:)
          end

          def unprocessable_entity errors, response
            body = problem[
              type: "/problem_details#device_setup",
              status: :unprocessable_entity,
              detail: "Invalid request headers.",
              instance: "/api/setup",
              extensions: {errors:}
            ]

            response.with body: body.to_json, format: :problem_details, status: 422
          end
        end
      end
    end
  end
end
