# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Actions
    module API
      module Screens
        # The patch action.
        # :reek:DataClump
        class Patch < Base
          include Deps[
            "aspects.screens.creators.temp_path",
            repository: "repositories.screen",
            model_repository: "repositories.model"
          ]
          include Initable[mold: Aspects::Screens::Mold, serializer: Serializers::Screen]
          include Dry::Monads[:result]

          using Refines::Actions::Response

          params do
            required(:id).filled(:integer)

            required(:screen).filled(:hash) do
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
              render update(screen, parameters[:screen]), response
            else
              unprocessable_content parameters.errors.to_h, response
            end
          end

          private

          def render result, response
            case result
              in Success(update) then response.body = {data: serializer.new(update).to_h}.to_json
              else unprocessable_content_on_failure result, response
            end
          end

          def update screen, parameters
            if parameters.key? :content
              merge(screen, parameters).bind { |attributes| build_mold attributes }
                                       .bind { |instance| screenshot instance, screen, parameters }
            else
              Success repository.update(screen.id, **parameters)
            end
          end

          def merge screen, parameters
            Success screen.to_h
                          .slice(:model_id, :label, :name)
                          .merge! parameters.slice(:model_id, :label, :name, :content)
          end

          def build_mold attributes
            id = attributes[:model_id]

            model_repository.find(id).then do |record|
              if record
                Success mold.for(record, **attributes.slice(:label, :name, :content))
              else
                Failure "Unable to find model for ID: #{id}."
              end
            end
          end

          def screenshot mold, screen, parameters
            temp_path.call(mold) { |path| replace path, screen, **parameters }
          end

          def replace(path, screen, **)
            path.open { |io| screen.replace io, metadata: {"filename" => path.basename} }
            Success repository.update(screen.id, image_data: screen.image_attributes, **)
          end

          def unprocessable_content errors, response
            body = problem[
              type: "/problem_details#screen_payload",
              status: :unprocessable_content,
              detail: "Validation failed.",
              instance: "/api/screens",
              extensions: {errors:}
            ]

            response.with body: body.to_json, format: :problem_details, status: 422
          end

          def unprocessable_content_on_failure result, response
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
