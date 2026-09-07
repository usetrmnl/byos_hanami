# frozen_string_literal: true

module Terminus
  module Actions
    module API
      module Extensions
        # The create action.
        # rubocop:todo-next I18n/RailsI18n/DecorateString
        class Create < Base
          include Deps[repository: "repositories.extension"]
          include Initable[serializer: Serializers::Extension]

          using Refines::Actions::Response

          # contract Contracts::Extensions::Create

          params do
            required(:extension).filled(:hash) do
              required(:name).filled :string
              required(:label).filled :string
              optional(:description).maybe :string
              optional(:mode).filled :string
              optional(:kind).filled :string
              optional(:tags).maybe :array
              optional(:static_body).maybe :hash
              optional(:template).maybe :string
              optional(:fields).maybe :array
              optional(:data).maybe :hash
              optional(:interval).filled :integer
              optional(:unit).filled :string
              optional(:days).maybe :array
              optional(:last_day_of_month).filled :bool
              optional(:start_at).filled :date_time
            end
          end

          def handle request, response
            parameters = request.params

            if parameters.valid?
              extension = repository.create parameters[:extension]
              response.with body: {data: serializer.new(extension).to_h}.to_json
            else
              unprocessable_content parameters.errors.to_h, response
            end
          end

          private

          def unprocessable_content errors, response
            response.with_details problem[
              type: "/problem_details#extension_payload",
              status: :unprocessable_content,
              detail: "Validation failed.",
              instance: "/api/extensions",
              extensions: {errors:}
            ]
          end
        end
      end
    end
  end
end
