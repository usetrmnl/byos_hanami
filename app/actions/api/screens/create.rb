# frozen_string_literal: true

require "dry/monads"
require "initable"
require "refinements/pathname"

module Terminus
  module Actions
    module API
      module Screens
        # The create action.
        class Create < Base
          include Deps[:settings, repository: "repositories.device"]
          include Initable[creator: proc { Terminus::Screens::Creator.new }]
          include Dry::Monads[:result]

          using Refinements::Pathname
          using Refines::Actions::Response

          params do
            required(:image).filled(:hash) do
              required(:model_id).filled :integer
              required(:label).filled :string
              required(:name).filled :string
              optional(:content).filled :string
              optional(:uri).filled :string
              optional(:data).filled :string
              optional(:preprocessed).filled :bool
            end
          end

          def handle request, response
            parameters = request.params
            device = repository.find_by api_key: request.env["HTTP_ACCESS_TOKEN"]

            return unauthorized response unless device

            if parameters.valid?
              save device, parameters[:image], response
            else
              unprocessable_entity_for_parameters parameters.errors.to_h, response
            end
          end

          private

          def save device, image, response
            result = creator.call output_path(device.slug, image), dimensions: "800x480", **image

            case result
              in Success(path)
                uri = uri_for path
                response.with body: {data: {name: path.basename, path: uri}}.to_json,
                              format: :json,
                              status: 200
              else unprocessable_entity_for_creation result, response
            end
          end

          def output_path slug, image
            settings.screens_root.join(slug).mkpath.join image.fetch(:file_name, "%<name>s.png")
          end

          def uri_for path
            "#{settings.api_uri}/#{path.relative_path_from config.public_directory}"
          end

          def unauthorized response
            response.with body: problem[status: :unauthorized].to_json,
                          format: :problem_details,
                          status: 401
          end

          def unprocessable_entity_for_parameters errors, response
            body = problem[
              type: "/problem_details#screen_payload",
              status: :unprocessable_entity,
              detail: "Validation failed.",
              instance: "/api/screens",
              extensions: {errors:}
            ]

            response.with body: body.to_json, format: :problem_details, status: 422
          end

          def unprocessable_entity_for_creation result, response
            body = problem[
              type: "/problem_details#screen_payload",
              status: :unprocessable_entity,
              detail: result.failure,
              instance: "/api/screens"
            ]

            response.with body: body.to_json, format: :problem_details, status: 422
          end
        end
      end
    end
  end
end
