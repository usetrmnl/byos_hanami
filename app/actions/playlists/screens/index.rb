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

          params { required(:playlist_id).filled :integer }

          # :reek:TooManyStatements
          def self.load_screens playlist
            screens = playlist.screens
            current_item = playlist.current_item
            enumerable = screens.ring

            return enumerable.first unless current_item

            enumerable.find do |first, middle, last|
              break first, middle, last if middle.id == current_item.screen_id
            end
          end

          def handle request, response
            playlist = repository.with_screens.by_pk(request.params[:playlist_id]).one
            before, current, after = self.class.load_screens playlist

            response.render view, playlist:, before:, current:, after:
          end
        end
      end
    end
  end
end
