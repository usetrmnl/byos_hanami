# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      module Items
        # The new action.
        class New < Terminus::Action
          include Deps[
            playlist_repository: "repositories.playlist",
            screen_repository: "repositories.screen"
          ]

          params { required(:playlist_id).filled :integer }

          def handle request, response
            parameters = request.params

            halt 422 unless parameters.valid?

            playlist = playlist_repository.find parameters[:playlist_id]
            response.render view, playlist:, screen_options:, layout: false
          end

          private

          def screen_options prompt: "Select..."
            screens = screen_repository.all
            initial = prompt && screens.any? ? [[prompt, nil]] : []

            screens.reduce(initial) { |all, screen| all.append [screen.label, screen.id] }
          end
        end
      end
    end
  end
end
