# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      # Updates a device's current playlist item by rotating to next screen.
      class Rotator
        include Deps[
          "aspects.screens.fetcher",
          playlist_repository: "repositories.playlist",
          item_repository: "repositories.playlist_item"
        ]
        include Dry::Monads[:result]

        def call device
          find_playlist(device.playlist_id).bind { |playlist| update_current_item playlist }
        end

        private

        def find_playlist id
          playlist = playlist_repository.find id

          return Success playlist if playlist

          Failure "Unable to rotate screen. Can't find playlist with ID: #{id.inspect}."
        end

        # :reek:TooManyStatements
        def update_current_item playlist
          current = playlist.current_item

          return Failure "Playlist has no current item." unless current

          playlist_id = playlist.id
          next_item = item_repository.next_item(after: current.position, playlist_id:)
          next_item_id = next_item.id

          unless current == next_item
            playlist_repository.update playlist_id, current_item_id: next_item_id
          end

          Success item_repository.find(next_item_id).screen
        end
      end
    end
  end
end
