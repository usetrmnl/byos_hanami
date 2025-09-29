# frozen_string_literal: true

require "initable"

module Terminus
  module Actions
    module Users
      # The new action.
      class New < Terminus::Action
        include Deps[:htmx, status_repository: "repositories.user_status"]

        def handle request, response
          view_settings = {statuses: status_repository.all}
          view_settings[:layout] = false if htmx.request? request.env, :request, "true"

          response.render view, **view_settings
        end
      end
    end
  end
end
