# frozen_string_literal: true

module Terminus
  module Actions
    module Users
      # The create action.
      class Create < Terminus::Action
        include Deps[
          :htmx,
          repository: "repositories.user",
          status_repository: "repositories.user_status",
          creator: "aspects.users.creator",
          index_view: "views.users.index"
        ]
        include Dry::Monads[:result]

        def handle request, response
          case creator.call(**request.params.to_h.slice(:user))
            in Success(user) then response.render index_view, **view_settings(request)
            in Failure(result) then error request, response, result
            # :nocov:
            # :nocov:
          end
        end

        private

        def view_settings request
          settings = {users: repository.all}
          settings[:layout] = false if htmx.request? request.env, :request, "true"
          settings
        end

        def error request, response, result
          response.render view,
                          user: repository.find(request.params[:id]),
                          statuses: status_repository.all,
                          fields: result[:user],
                          errors: result.errors[:user],
                          layout: false
        end
      end
    end
  end
end
