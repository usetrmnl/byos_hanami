# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      # The update action.
      class Update < Terminus::Action
        include Deps[
          repository: "repositories.playlist",
          item_repository: "repositories.playlist_item",
          show_view: "views.playlists.show"
        ]

        params do
          required(:id).filled :integer

          required(:playlist).hash do
            required(:label).filled :string
            required(:name).filled :string
          end
        end

        def handle request, response
          parameters = request.params
          playlist = repository.find parameters[:id]

          halt :unprocessable_content unless playlist

          if parameters.valid?
            save playlist, parameters, response
          else
            error playlist, parameters, response
          end
        end

        private

        def save playlist, parameters, response
          id = playlist.id
          repository.update id, **parameters[:playlist]

          response.render show_view,
                          playlist: repository.find(id),
                          items: item_repository.where(playlist_id: id),
                          layout: false
        end

        def error playlist, parameters, response
          response.render view,
                          playlist:,
                          fields: parameters[:playlist],
                          errors: parameters.errors[:playlist],
                          layout: false
        end
      end
    end
  end
end
