# frozen_string_literal: true

module Terminus
  module Actions
    module Users
      # The create action.
      class Create < Terminus::Action
        include Deps[:htmx, repository: "repositories.user", index_view: "views.users.index"]

        params do
          required(:user).filled(:hash) do
            required(:name).filled :string
            required(:email).filled :string
          end
        end

        def handle request, response
          parameters = request.params

          if parameters.valid?
            repository.create parameters[:user]
            response.render index_view, **view_settings(request, parameters)
          else
            error response, parameters
          end
        end

        private

        def view_settings request, _parameters
          settings = {users: repository.all}
          settings[:layout] = false if htmx.request? request.env, :request, "true"
          settings
        end

        def error response, parameters
          response.render view,
                          users: repository.all,
                          fields: parameters[:user],
                          errors: parameters.errors[:user],
                          layout: false
        end
      end
    end
  end
end
