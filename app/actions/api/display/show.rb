# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Actions
    module API
      module Display
        # The show action.
        class Show < Terminus::Action
          include Dry::Monads[:result]
          include Deps[
            :settings,
            repository: "repositories.device",
            synchronizer: "aspects.synchronizers.device"
          ]

          include Initable[
            fetcher: proc { Terminus::HTTP::Images::Rotator.new },
            model: Aspects::API::Responses::Display
          ]

          using Refines::Actions::Response

          format :json

          params { optional(:base_64).filled :integer }

          def handle request, response
            environment = request.env

            case synchronizer.call environment
              in Success(device)
                record = build_record fetch_image(request.params, environment), device
                response.with body: record.to_json, status: 200
              else response.with body: model[status: 404].to_json, status: 404
            end
          end

          private

          def fetch_image parameters, environment
            encryption = :base_64 if (environment["HTTP_BASE64"] || parameters[:base_64]) == "true"
            fetcher.call images_uri: "#{settings.api_uri}/assets", encryption:
          end

          def build_record image, device
            model[
              **image.slice(:image_url, :filename),
              refresh_rate: device.refresh_rate,
              status: 0
            ]
          end
        end
      end
    end
  end
end
