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

            mirror playlist, parameters
            render playlist, request, response
          end

          private

          def mirror playlist, parameters
            device_repository.mirror_playlist parameters.dig(:mirror, :device_ids), playlist.id
          end

          def render playlist, request, response
            htmx.response! response.headers, push_url: routes.path(:playlist, id: playlist.id)
            response.render view, **view_settings(request, playlist)
          end

          def view_settings request, playlist
            settings = {playlist:, items: playlist_item_repository.all_by(playlist_id: playlist.id)}
            settings[:layout] = false if htmx.request? request.env, :request, "true"
            settings
          end
        end
      end
    end
  end
end
