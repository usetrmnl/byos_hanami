# frozen_string_literal: true

require "dry/monads"
require "initable"
require "trmnl/api"

module Terminus
  module Actions
    module API
      module Display
        # The show action.
        # :reek:DataClump
        class Show < Base
          include Deps[
            :settings,
            "aspects.screens.encoder",
            "aspects.screens.rotator",
            "aspects.screens.gaffer",
            firmware_repository: "repositories.firmware",
            synchronizer: "aspects.devices.synchronizer"
          ]

          include Initable[model: TRMNL::API::Models::Display]
          include Dry::Monads[:result]

          using Refines::Actions::Response

          def handle request, response
            case synchronizer.call request.env
              in Success(device) then process device, request, response
              else not_found response
            end
          end

          protected

          def authorize(*) = nil

          private

          def process device, request, response
            rotator.call(device)
                   .bind { |screen| encode screen, request.params, request.env }
                   .either -> image_attributes { success device, image_attributes, response },
                           -> message { error_for device, message, response }
          end

          def success device, image_attributes, response
            response.body = build_payload(device, image_attributes).to_json
          end

          def error_for device, message, response
            gaffer.call(device, message).bind { |screen| any_error device, screen, response }
          end

          def build_payload device, image_attributes
            model[
              firmware_url: fetch_firmware_uri(device),
              **image_attributes,
              **device.as_api_display
            ]
          end

          def fetch_firmware_uri device
            firmware_repository.latest.then do |firmware|
              break unless firmware
              break if device.firmware_version == firmware.version

              firmware.attachment_uri host: settings.api_uri
            end
          end

          def encode screen, parameters, environment
            encryption = :base_64 if (environment["HTTP_BASE64"] || parameters[:base_64]) == "true"
            encoder.call screen, encryption:
          end

          def any_error device, screen, response
            payload = model[
              firmware_url: fetch_firmware_uri(device),
              filename: screen.image_name,
              image_url: screen.image_uri(host: settings.api_uri),
              **device.as_api_display
            ]

            response.body = payload.to_json
          end

          def not_found response
            payload = problem[
              type: "/problem_details#device_id",
              status: __method__,
              detail: "Invalid device ID.",
              instance: "/api/display"
            ]

            response.with body: payload.to_json, format: :problem_details, status: 404
          end
        end
      end
    end
  end
end
