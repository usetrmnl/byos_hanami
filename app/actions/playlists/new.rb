# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      # The new action.
      class New < Action
        include Deps[:htmx]

        def handle request, response
          view_settings = {fields: {mode: :automatic}}
          view_settings[:layout] = false if htmx.request? request.env, :request, "true"

          response.render view, **view_settings
        end
      end
    end
  end
end
