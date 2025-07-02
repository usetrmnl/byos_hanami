# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      module Mirror
        # The update action.
        class Update < Hanami::Action
          include Deps[
            :htmx,
            repository: "repositories.playlist",
            device_repository: "repositories.device",
            playlist_item_repository: "repositories.playlist_item",
            view: "views.playlists.show"
          ]

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
            settings = {playlist:, items: playlist_item_repository.all}
            settings[:layout] = false if htmx.request(**request.env).request?
            settings
          end
        end
      end
    end
  end
end
