# frozen_string_literal: true

module Terminus
  module Actions
    module Models
      # The edit action.
      class Edit < Terminus::Action
        include Deps[:htmx, repository: "repositories.model"]

        params { required(:id).filled :integer }

        def handle request, response
          parameters = request.params

          halt :unprocessable_content unless parameters.valid?

          response.render view, **view_settings(request, parameters)
        end

        private

        def view_settings request, parameters
          settings = {model: repository.find(parameters[:id])}
          settings[:layout] = false if htmx.request? request.env, :request, "true"
          settings
        end
      end
    end
  end
end
