# frozen_string_literal: true

require "dry/core"
require "dry/monads"
require "initable"
require "petail"
require "trmnl/api"

module Terminus
  module Actions
    module API
      module Display
        # The show action.
        class Show < Terminus::Action
          include Deps[
            image_fetcher: "aspects.screens.rotator",
            firmware_fetcher: "aspects.firmware.fetcher",
            synchronizer: "aspects.synchronizers.device"
          ]

          include Initable[problem: Petail, model: TRMNL::API::Models::Display]
          include Dry::Monads[:result]

          using Refines::Actions::Response

          format :json

          def handle request, response
            environment = request.env

            case synchronizer.call environment
              in Success(device)
                record = build_record fetch_image(request.params, environment), device
                response.with body: record.to_json, status: 200
              else not_found response
            end
          end

          private

          def fetch_image parameters, environment
            encrypted, mac_address = environment.values_at "HTTP_BASE64", "HTTP_ID"
            encryption = :base_64 if (encrypted || parameters[:base_64]) == "true"

            image_fetcher.call mac_address.tr(":", Dry::Core::EMPTY_STRING), encryption:
          end

          def build_record image, device
            model[
              firmware_url: fetch_firmware_uri(device),
              **image.slice(:image_url, :filename),
              **device.as_api_display
            ]
          end

          def fetch_firmware_uri device
            firmware_fetcher.call.first.then do
              it.uri if it && device.firmware_version != it.version
            end
          end

          def not_found response
            body = problem[
              status: __method__,
              detail: "Unable to find device.",
              instance: "/api/display"
            ]

            response.with body: body.to_json, format: :problem_details, status: 404
          end
        end
      end
    end
  end
end
