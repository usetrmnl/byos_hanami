# frozen_string_literal: true

module Terminus
  module Actions
    module Models
      # The create action.
      class Create < Action
        include Deps[:htmx, repository: "repositories.model", index_view: "views.models.index"]

        contract Contracts::Models::Create

        def handle request, response
          parameters = request.params

          if parameters.valid?
            repository.create parameters[:model]
            response.render index_view, **view_settings(request)
          else
            error response, parameters
          end
        end

        private

        def view_settings request
          settings = {models: repository.all}
          settings[:layout] = false if htmx.request? request.env, :request, "true"
          settings
        end

        def error response, parameters
          response.render view,
                          models: repository.all,
                          fields: parameters[:model],
                          errors: parameters.errors[:model],
                          layout: false
        end
      end
    end
  end
end
