# frozen_string_literal: true

require "refinements/array"

module Terminus
  module Actions
    module Playlists
      module Screens
        # The show action.
        class Show < Hanami::Action
          include Deps[
            :htmx,
            repository: "repositories.playlist",
            item_repository: "repositories.playlist_item"
          ]

          using Refinements::Array

          params do
            required(:playlist_id).filled :integer
            required(:id).filled :integer
          end

          def handle request, response
            parameters = request.params

            halt :unprocessable_content unless parameters.valid?

            response.render view, **view_settings(request, update_current_item(parameters))
          end

          private

          def update_current_item parameters
            playlist_id = parameters[:playlist_id]

            repository.with_screens.by_pk(playlist_id).one.tap do |playlist|
              return playlist if playlist.automatic?

              item = item_repository.find_by playlist_id:, screen_id: parameters[:id]
              repository.update playlist_id, current_item_id: item.id
            end
          end

          def view_settings request, playlist
            before, current, after = playlist.screens.ring.find do |first, middle, last|
              break first, middle, last if middle.id == request.params[:id]
            end

            view_settings = {playlist:, before:, current:, after:}
            view_settings[:layout] = false if htmx.request? request.env, :request, "true"

            view_settings
          end
        end
      end
    end
  end
end
