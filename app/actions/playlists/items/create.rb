# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      module Items
        # The create action.
        class Create < Terminus::Action
          include Deps[
            repository: "repositories.playlist_item",
            playlist_repository: "repositories.playlist",
            show_view: "views.playlists.items.show"
          ]

          params do
            required(:playlist_id).filled :integer
            required(:playlist_item).hash { required(:screen_id).filled :integer }
          end

          def handle request, response
            parameters = request.params
            playlist = playlist_repository.find parameters[:playlist_id]

            halt :unprocessable_content unless parameters.valid?

            response.render show_view, item: create(playlist, parameters), layout: false
          end

          private

          def create playlist, parameters
            playlist_id = playlist.id
            item = repository.create_with_position playlist_id:, **parameters[:playlist_item]

            playlist_repository.update_current_item playlist_id, item
            item
          end
        end
      end
    end
  end
end
