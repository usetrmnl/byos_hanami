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
            new_view: "views.playlists.items.new",
            show_view: "views.playlists.items.show"
          ]

          params do
            required(:playlist_id).filled :integer
            required(:playlist_item).hash { required(:screen_id).filled :integer }
          end

          def handle request, response
            parameters = request.params
            playlist = playlist_repository.find parameters[:playlist_id]

            if parameters.valid?
              item = repository.create_with_position playlist_id: playlist.id,
                                                     **parameters[:playlist_item]
              response.render show_view, item:, layout: false
            else
              render_new playlist, parameters, response
            end
          end

          private

          # :reek:FeatureEnvy
          def render_new playlist, parameters, response
            response.render new_view,
                            playlist:,
                            screen_options:,
                            fields: parameters[:playlist_item],
                            errors: parameters.errors[:playlist_item],
                            layout: false
          end

          # :reek:FeatureEnvy
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
