# frozen_string_literal: true

require "refinements/array"

module Terminus
  module Actions
    module Playlists
      module Screens
        # The index action.
        class Index < Hanami::Action
          include Deps[repository: "repositories.playlist", view: "views.playlists.screens.show"]

          using Refinements::Array

          def handle request, response
            playlist = repository.with_screens.by_pk(request.params[:playlist_id]).one
            before, current, after = playlist.screens.ring.first

            response.render view, playlist:, before:, current:, after:
          end
        end
      end
    end
  end
end
