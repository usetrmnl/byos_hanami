# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      # The new action.
      class New < Terminus::Action
        include Deps[
          :htmx,
          "aspects.devices.defaulter",
          model_repository: "repositories.model",
          playlist_repository: "repositories.playlist"
        ]

        def handle request, response
          view_settings = {
            models: model_repository.all,
            playlists: playlist_repository.all,
            fields: defaulter.call
          }
          view_settings[:layout] = false if htmx.request(**request.env).request?

          response.render view, **view_settings
        end
      end
    end
  end
end
