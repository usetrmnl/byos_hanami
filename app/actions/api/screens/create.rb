# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Actions
    module API
      module Screens
        # The create action.
        class Create < Base
          include Deps["aspects.screens.creator", repository: "repositories.screen"]
          include Initable[serializer: Serializers::Screen]
          include Dry::Monads[:result]

          using Refines::Actions::Response

          params do
            required(:screen).filled(:hash) do
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

            if parameters.valid?
              save parameters[:screen], response
            else
              unprocessable_content_for_parameters parameters.errors.to_h, response
            end
          end

          private

          def save parameters, response
            result = creator.call(**parameters)

            case result
              in Success(screen)
                response.body = {data: serializer.new(screen).to_h}.to_json
              else unprocessable_content_for_creation result, response
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

          def unprocessable_content_for_creation result, response
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
