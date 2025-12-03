# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      module Clone
        # The new action.
        class New < Terminus::Action
          include Deps[repository: "repositories.playlist"]

          def handle request, response
            playlist = repository.find request.params[:playlist_id]
            fields = {label: "#{playlist.label} Clone", name: "#{playlist.name}_clone"}

            response.render view, playlist:, fields:
          end
        end
      end
    end
  end
end
