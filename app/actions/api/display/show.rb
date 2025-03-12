# frozen_string_literal: true

module Terminus
  module Actions
    module API
      module Display
        # The show action.
        class Show < Terminus::Action
          include Deps[:settings, repository: "repositories.device"]

          using Refines::Actions::Response

          format :json

          params { optional(:base_64).filled :integer }

          def initialize(
            fetcher: Terminus::Images::Rotator.new,
            model: Models::API::Responses::Display,
            **
          )
            @fetcher = fetcher
            @model = model
            super(**)
          end

          def handle request, response
            device = load_device request

            if device
              record = build_record fetch_image(request.params, request.env), device
              response.with body: record.to_json, status: 200
            else
              response.with body: model[status: 404].to_json, status: 404
            end
          end

          private

          attr_reader :fetcher, :model

          def load_device(request) = repository.find_by_api_key request.env["HTTP_ACCESS_TOKEN"]

          def fetch_image parameters, environment
            encryption = :base_64 if (environment["HTTP_BASE64"] || parameters[:base_64]) == "true"

            fetcher.call Pathname(settings.images_root).join("generated"),
                         images_uri: "#{settings.app_url}/assets/images",
                         encryption:
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
