# frozen_string_literal: true

module Terminus
  module Actions
    module Extensions
      # The show action.
      class Show < Terminus::Action
        include Deps[:htmx, repository: "repositories.extension"]

        params { required(:id).filled :integer }

        def handle request, response
          parameters = request.params

          halt :unprocessable_entity unless parameters.valid?

          response.render view, **view_settings(request, parameters)
        end

        private

        def view_settings request, parameters
          settings = {extension: repository.find(parameters[:id])}
          settings[:layout] = false if htmx.request? request.env, :request, "true"
          settings
        end
      end
    end
  end
end
