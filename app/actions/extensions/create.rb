# frozen_string_literal: true

require "refinements/hash"

module Terminus
  module Actions
    module Extensions
      # The create action.
      class Create < Terminus::Action
        include Deps[
          :htmx,
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
            response.render index_view, **view_settings(request)
          else
            error response, parameters
          end
        end

        private

        def save parameters
          attributes, model_ids = parameters.to_h.values_at :extension, :model_ids
          extension = repository.create_with_models attributes, Array(model_ids)

          schedule.upsert(*extension.to_schedule)
        end

        def view_settings request
          settings = {extensions: repository.all}

          settings[:layout] = false if htmx.request? request.env, :request, "true"
          settings
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
