# frozen_string_literal: true

require "refinements/hash"

module Terminus
  module Actions
    module Extensions
      module Clone
        # The create action.
        class Create < Hanami::Action
          include Deps["aspects.jobs.schedule", repository: "repositories.extension"]

          using Refinements::Hash

          params do
            required(:extension_id).filled :integer
            required(:extension).filled Schemas::Extensions::Upsert
          end

          def handle request, response
            parameters = request.params

            if parameters.valid?
              save parameters, response
            else
              error response, parameters
            end
          end

          private

          def save parameters, response
            attributes = parameters[:extension]

            extension = repository.create_with_models attributes, Array(attributes[:model_ids])
            extension = repository.update_with_devices extension.id,
                                                       {},
                                                       Array(attributes[:device_ids])

            schedule.upsert(*extension.to_schedule)
            response.redirect_to routes.path(:extensions)
          end

          def error response, parameters
            fields = parameters[:extension].transform_with!(
              start_at: -> value { value.strftime("%Y-%m-%dT%H:%M:%S") }
            )

            response.render view,
                            extension: repository.find(parameters[:extension_id]),
                            fields:,
                            errors: parameters.errors[:extension]
          end
        end
      end
    end
  end
end
