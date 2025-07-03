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
          new_view: "views.screens.new",
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
            response.render index_view, **view_settings(request, parameters)
          else
            render_new response, parameters
          end
        end

        private

        def view_settings request, _parameters
          settings = {screens: repository.all}
          settings[:layout] = false if htmx.request(**request.env).request?
          settings
        end

        # :reek:FeatureEnvy
        def render_new response, parameters
          response.render new_view,
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
