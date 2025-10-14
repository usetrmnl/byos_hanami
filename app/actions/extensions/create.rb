# frozen_string_literal: true

module Terminus
  module Actions
    module Extensions
      # The create action.
      class Create < Terminus::Action
        include Deps[
          :htmx,
          repository: "repositories.extension",
          index_view: "views.extensions.index"
        ]

        contract Contracts::Extensions::Create

        def handle request, response
          parameters = request.params

          if parameters.valid?
            attributes, model_ids = parameters.to_h.values_at :extension, :model_ids
            repository.create_with_models attributes, Array(model_ids)
            response.render index_view, **view_settings(request, parameters)
          else
            error response, parameters
          end
        end

        private

        def view_settings request, _parameters
          settings = {extensions: repository.all}
          settings[:layout] = false if htmx.request? request.env, :request, "true"
          settings
        end

        def error response, parameters
          response.render view,
                          fields: parameters[:extension],
                          errors: parameters.errors[:extension],
                          layout: false
        end
      end
    end
  end
end
