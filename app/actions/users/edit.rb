# frozen_string_literal: true

module Terminus
  module Actions
    module Users
      # The edit action.
      class Edit < Terminus::Action
        include Deps[
          :htmx,
          repository: "repositories.user",
          status_repository: "repositories.user_status"
        ]

        params { required(:id).filled :integer }

        def handle request, response
          parameters = request.params

          halt :unprocessable_content unless parameters.valid?

          response.render view, **view_settings(request, parameters)
        end

        private

        def view_settings request, parameters
          settings = {user: repository.find(parameters[:id]), statuses: status_repository.all}
          settings[:layout] = false if htmx.request? request.env, :request, "true"
          settings
        end
      end
    end
  end
end
