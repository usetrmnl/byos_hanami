# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Actions
    module API
      module Display
        # The show action.
        class Show < Terminus::Action
          include Deps[
            :settings,
            repository: "repositories.device",
            image_fetcher: "aspects.screens.rotator",
            firmware_fetcher: "aspects.firmware.fetcher",
            synchronizer: "aspects.synchronizers.device"
          ]

          include Initable[model: Endpoints::Display::Response]
          include Dry::Monads[:result]

          using Refines::Actions::Response

          format :json

          params { optional(:base_64).filled :integer }

          def handle request, response
            environment = request.env

            case synchronizer.call environment
              in Success(device)
                record = build_record fetch_image(request.params, environment), device
                response.with body: record.to_json, status: 200
              else response.with body: model.new.to_json, status: 404
            end
          end

          private

          def fetch_image parameters, environment
            encryption = :base_64 if (environment["HTTP_BASE64"] || parameters[:base_64]) == "true"
            image_fetcher.call images_uri: "#{settings.api_uri}/assets", encryption:
          end

          def fetch_firmware
            firmware_fetcher.call
                            .relative_path_from(config.public_directory)
                            .then { |relative_path| "#{settings.api_uri}/#{relative_path}" }
          end

          def build_record image, device
            model[
              firmware_url: fetch_firmware,
              **image.slice(:image_url, :filename),
              **device.as_api_display
            ]
          end
        end
      end
    end
  end
end
