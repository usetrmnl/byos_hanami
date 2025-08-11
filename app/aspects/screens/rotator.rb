# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      # Updates a device's current playlist item by rotating to next screen.
      class Rotator
        include Deps[
          "aspects.screens.sleeper",
          playlist_repository: "repositories.playlist",
          item_repository: "repositories.playlist_item"
        ]
        include Dry::Monads[:result]

        def call device
          if device.asleep?
            sleeper.call device
          else
            find_playlist(device.playlist_id).fmap { |playlist| update_current_item playlist }
                                             .bind { |item_id| find_screen item_id }
          end
        end

        private

        def find_playlist id
          playlist = playlist_repository.find id

          return Success playlist if playlist

          Failure "Unable to obtain next screen. Can't find playlist with ID: #{id.inspect}."
        end

        def update_current_item playlist
          playlist_id = playlist.id
          next_item = item_repository.next_item(after: playlist.current_item_position, playlist_id:)
          next_item_id = next_item.id if next_item

          playlist_repository.update playlist_id, current_item_id: next_item_id
          next_item_id
        end

        def find_screen item_id
          item_repository.find(item_id).then do |item|
            return Success item.screen if item

            Failure "Unable to obtain next screen. Playlist has no items."
          end
        end
      end
    end
  end
end
