# frozen_string_literal: true

require "initable"

module Terminus
  module Actions
    module API
      module Models
        # The create action.
        class Create < Base
          include Deps[repository: "repositories.model"]
          include Initable[serializer: Serializers::Model]

          using Refines::Actions::Response

          params do
            required(:model).filled(:hash) do
              required(:name).filled :string
              required(:label).filled :string
              optional(:description).filled :string
              optional(:mime_type).filled :string
              optional(:colors).filled :integer
              optional(:bit_depth).filled :integer
              optional(:rotation).filled :integer
              optional(:offset_x).filled :integer
              optional(:offset_y).filled :integer
              required(:width).filled :integer
              required(:height).filled :integer
              required(:published_at).filled :date_time
            end
          end

          def handle request, response
            parameters = request.params

            if parameters.valid?
              model = repository.create parameters[:model]
              response.body = {data: serializer.new(model).to_h}.to_json
            else
              unprocessable_content parameters, response
            end
          end

          private

          def unprocessable_content parameters, response
            body = problem[
              type: "/problem_details#model_payload",
              status: :unprocessable_content,
              detail: "Validation failed.",
              instance: "/api/models",
              extensions: {errors: parameters.errors.to_h}
            ]

            response.with body: body.to_json, format: :problem_details, status: 422
          end
        end
      end
    end
  end
end
