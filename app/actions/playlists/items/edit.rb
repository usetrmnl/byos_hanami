# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      module Items
        # The edit action.
        class Edit < Terminus::Action
          include Deps[
            repository: "repositories.playlist_item",
            screen_repository: "repositories.screen"
          ]

          params do
            required(:playlist_id).filled :integer
            required(:id).filled :integer
          end

          def handle request, response
            parameters = request.params

            halt :unprocessable_content unless parameters.valid?

            item = repository.find_by playlist_id: parameters[:playlist_id], id: parameters[:id]

            response.render view, screen_options:, item:, layout: false
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
