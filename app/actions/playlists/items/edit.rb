# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      module Items
        # The edit action.
        class Edit < Terminus::Action
          include Deps[repository: "repositories.playlist_item"]

          params do
            required(:playlist_id).filled :integer
            required(:id).filled :integer
          end

          def handle request, response
            parameters = request.params

            halt :unprocessable_entity unless parameters.valid?

            response.render view, **view_settings(request, parameters)
          end

          private

          def view_settings request, parameters
            playlist = repository.find parameters[:id]
            settings = {playlist:, items: item_repository.all_by(playlist_id: playlist.id)}

            settings[:layout] = false if request.env.key? "HTTP_HX_REQUEST"
            settings
          end
        end
      end
    end
  end
end
