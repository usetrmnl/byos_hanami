# frozen_string_literal: true

module Terminus
  module Actions
    module API
      module Screens
        # The patch action.
        class Patch < Base
          include Deps["aspects.screens.updater", repository: "repositories.screen"]
          include Initable[serializer: Serializers::Screen]

          using Refines::Actions::Response

          params do
            required(:id).filled(:integer)

            required(:screen).filled(:hash) do
              optional(:model_id).filled :integer
              optional(:label).filled :string
              optional(:name).filled :string
              optional(:content).filled :string
              optional(:uri).filled :string
              optional(:data).filled :string
              optional(:preprocessed).filled :bool
            end
          end

          def handle request, response
            parameters = request.params
            screen = repository.find parameters[:id]

            if parameters.valid? && screen
              save screen, parameters[:screen], response
            else
              unprocessable_content_for_parameters parameters.errors.to_h, response
            end
          end

          private

          def save screen, parameters, response
            result = updater.call(screen, **parameters)

            case result
              in Success(update) then response.body = {data: serializer.new(update).to_h}.to_json
              else unprocessable_content_for_update result, response
            end
          end

          def unprocessable_content_for_parameters errors, response
            body = problem[
              type: "/problem_details#screen_payload",
              status: :unprocessable_content,
              detail: "Validation failed.",
              instance: "/api/screens",
              extensions: {errors:}
            ]

            response.with body: body.to_json, format: :problem_details, status: 422
          end

          def unprocessable_content_for_update result, response
            body = problem[
              type: "/problem_details#screen_payload",
              status: :unprocessable_content,
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
