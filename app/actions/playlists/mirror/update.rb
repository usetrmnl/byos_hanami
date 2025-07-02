# frozen_string_literal: true

require "htmx"
require "initable"

module Terminus
  module Actions
    module Playlists
      module Mirror
        # The update action.
        class Update < Hanami::Action
          include Deps[
            repository: "repositories.playlist",
            device_repository: "repositories.device",
            view: "views.playlists.show"
          ]

          include Initable[htmx_request: HTMX::Headers::Request]

          params do
            required(:id).filled :integer
            optional(:mirror).filled(:hash) { required(:device_ids).array :integer }
          end

          def handle request, response
            parameters = request.params
            playlist = repository.find parameters[:id]

            halt :not_found unless playlist

            device_repository.mirror_playlist parameters.dig(:mirror, :device_ids), playlist.id
            response.render view, **view_settings(request, playlist)
          end

          private

          def view_settings request, playlist
            settings = {playlist:}
            settings[:layout] = false if htmx_request.for(**request.env).request == "true"
            settings
          end
        end
      end
    end
  end
end
