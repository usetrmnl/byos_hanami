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
                                             .bind { |item| extract_screen item }
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

          playlist_repository.update_current_item playlist_id, next_item
          next_item
        end

        def extract_screen item
          return Success item.screen if item

          Failure "Unable to obtain next screen. Playlist has no items."
        end
      end
    end
  end
end
