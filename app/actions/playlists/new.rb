# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      # The new action.
      class New < Terminus::Action
        include Deps[:htmx]

        def handle request, response
          view_settings = {}
          view_settings[:layout] = false if htmx.request(**request.env).request?

          response.render view, **view_settings
        end
      end
    end
  end
end
