# frozen_string_literal: true

require "refinements/hash"

module Terminus
  module Actions
    module Extensions
      # The create action.
      class Create < Action
        include Deps[
          :htmx_layout,
          "aspects.jobs.schedule",
          repository: "repositories.extension",
          index_view: "views.extensions.index"
        ]

        using Refinements::Hash

        contract Contracts::Extensions::Create

        def handle request, response
          parameters = request.params

          if parameters.valid?
            save parameters
            response.render index_view,
                            extensions: repository.all,
                            layout: htmx_layout.call(request)
          else
            error response, parameters
          end
        end

        private

        def save parameters
          attributes = parameters[:extension]
          model_ids, device_ids = parameters.to_h.values_at :model_ids, :device_ids
          extension = repository.create_with_models attributes, Array(model_ids)

          repository.update_with_devices extension.id, {}, Array(device_ids)
          schedule.upsert(*extension.to_schedule)
        end

        def error response, parameters
          fields = parameters[:extension].transform_with!(
            start_at: -> value { value.strftime("%Y-%m-%dT%H:%M:%S") }
          )

          response.render view, fields:, errors: parameters.errors[:extension], layout: false
        end
      end
    end
  end
end
