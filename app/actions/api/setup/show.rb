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
          include Initable[payload: Terminus::Models::Firmware::Setup]
          include Dry::Monads[:result]

          using Refines::Actions::Response

          params do
            required(:HTTP_ID).filled Types::MACAddress
            optional(:HTTP_FW_VERSION).maybe Types::String.constrained(format: Versionaire::PATTERN)
          end

          def handle request, response
            environment = request.env

            case contract.call(environment).to_monad
              in Success then create environment, response
              in Failure(result) then unprocessable_content result.errors.to_h, response
              # :nocov:
              # :nocov:
            end
          end

          protected

          def authorize(*) = nil

          private

          def create environment, response
            mac_address, firmware_version = environment.values_at "HTTP_ID", "HTTP_FW_VERSION"

            provisioner.call(model_id: find_model_id, mac_address:, firmware_version:)
                       .either -> device { render_success device, response },
                               -> error { not_found error, response }
          end

          # FIX: Use dynamic lookup once Firmware Issue 199 is resolved.
          def find_model_id = model_repository.find_by(name: "og_png").then { it.id if it }

          def render_success device, response
            response.body = payload.for(device).to_json
          end

          def not_found error, response
            body = problem[
              type: "/problem_details#device_setup",
              status: __method__,
              detail: error,
              instance: "/api/setup"
            ]

            response.with body: body.to_json, format: :problem_details, status: 422
          end

          def unprocessable_content errors, response
            body = problem[
              type: "/problem_details#device_setup",
              status: __method__,
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
