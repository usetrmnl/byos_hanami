# frozen_string_literal: true

module Terminus
  module Actions
    module Screens
      # The create action.
      class Create < Terminus::Action
        include Deps[
          :htmx,
          repository: "repositories.screen",
          model_repository: "repositories.model",
          index_view: "views.screens.index"
        ]

        params do
          required(:screen).filled(:hash) do
            required(:model_id).filled :integer
            required(:label).filled :string
            required(:name).filled :string
          end
        end

        def handle request, response
          parameters = request.params

          if parameters.valid?
            repository.create parameters[:screen]
            response.render index_view, **view_settings(request)
          else
            error response, parameters
          end
        end

        private

        def view_settings request
          settings = {screens: repository.all}
          settings[:layout] = false if htmx.request? request.env, :request, "true"
          settings
        end

        def error response, parameters
          response.render view,
                          models: model_repository.all,
                          screen: nil,
                          fields: parameters[:screen],
                          errors: parameters.errors[:screen],
                          layout: false
        end
      end
    end
  end
end
