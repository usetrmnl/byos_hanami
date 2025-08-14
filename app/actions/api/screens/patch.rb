# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Actions
    module API
      module Screens
        # The patch action.
        class Patch < Base
          include Deps[
            "aspects.screens.creators.temp_path",
            repository: "repositories.screen",
            model_repository: "repositories.model"
          ]
          include Initable[
            payload: Aspects::Screens::Creators::Payload,
            serializer: Serializers::Screen
          ]
          include Dry::Monads[:result]

          using Refines::Actions::Response

          params do
            required(:id).filled(:integer)

            required(:image).filled(:hash) do
              optional(:model_id).filled :integer
              optional(:label).filled :string
              optional(:name).filled :string
              optional(:content).filled :string
            end
          end

          def handle request, response
            parameters = request.params
            screen = repository.find parameters[:id]

            if parameters.valid? && screen
              process update(screen, parameters[:image]), response
            else
              unprocessable_entity parameters.errors.to_h, response
            end
          end

          private

          # :reek:TooManyStatements
          def update screen, parameters
            id = screen.id

            if parameters.key? :content
              temp_path.call build_payload(screen, parameters) do |path|
                replace path, screen, **parameters
              end
            else
              Success repository.update(id, **parameters)
            end
          end

          # :reek:FeatureEnvy
          def replace(path, screen, **)
            path.open { |io| screen.replace io, metadata: {"filename" => path.basename} }
            Success repository.update(screen.id, image_data: screen.image_attributes, **)
          end

          def build_payload screen, parameters
            attributes = screen.to_h
                               .slice(:model_id, :label, :name)
                               .merge!(parameters.slice(:model_id, :label, :name, :content))

            payload[
              model: model_repository.find(attributes[:model_id]),
              **attributes.slice(:label, :name, :content)
            ]
          end

          def process result, response
            case result
              in Success(update)
                response.body = {data: serializer.new(update).to_h}.to_json
              else unprocessable_entity_on_failure result, response
            end
          end

          def unprocessable_entity errors, response
            body = problem[
              type: "/problem_details#screen_payload",
              status: :unprocessable_entity,
              detail: "Validation failed.",
              instance: "/api/screens",
              extensions: {errors:}
            ]

            response.with body: body.to_json, format: :problem_details, status: 422
          end

          def unprocessable_entity_on_failure result, response
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
