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
            find_playlist(device.playlist_id).fmap { |playlist| auto_update_current_item playlist }
                                             .bind { |item| obtain_screen item }
          end
        end

        private

        def find_playlist id
          playlist = playlist_repository.find id

          return Success playlist if playlist

          Failure "Unable to obtain next screen. Can't find playlist with ID: #{id.inspect}."
        end

        def auto_update_current_item playlist
          item_repository.next_item(after: playlist.current_item_position, playlist_id: playlist.id)
                         .tap do |item|
                           playlist_repository.auto_update_current_item playlist, item.id if item
                         end
        end

        def obtain_screen item
          return Success item.screen if item

          Failure "Unable to obtain next screen. Playlist has no items."
        end
      end
    end
  end
end
