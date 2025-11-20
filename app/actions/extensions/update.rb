# frozen_string_literal: true

require "refinements/hash"

module Terminus
  module Actions
    module Extensions
      # The update action.
      class Update < Terminus::Action
        include Deps["aspects.jobs.schedule", repository: "repositories.extension"]

        using Refinements::Hash

        contract Contracts::Extensions::Update

        def handle request, response
          parameters = request.params
          extension = repository.find parameters[:id]

          halt :unprocessable_content unless extension

          if parameters.valid?
            render extension, parameters, response
          else
            error extension, parameters, response
          end
        end

        private

        def render extension, parameters, response
          update extension, *parameters.to_h.values_at(:extension, :model_ids)

          response.flash[:notice] = "Changes saved."
          response.redirect_to routes.path(:extension_edit, id: extension.id)
        end

        def update extension, attributes, model_ids
          old_name = extension.screen_name
          extension = repository.update_with_models extension.id, attributes, Array(model_ids)

          schedule.upsert(*extension.to_schedule, old_name:)
        end

        def error extension, parameters, response
          fields = parameters[:extension].transform_with!(
            start_at: -> value { value.strftime("%Y-%m-%dT%H:%M:%S") }
          )

          response.render view, extension:, fields:, errors: parameters.errors[:extension]
        end
      end
    end
  end
end
