# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      # Fetches a device's current screen.
      class Fetcher
        include Deps[
          playlist_repository: "repositories.playlist",
          playlist_item_repository: "repositories.playlist_item"
        ]
        include Dry::Monads[:result]

        def call device
          find_playlist(device.playlist_id).bind { |playlist| find_current_item playlist }
                                           .fmap(&:screen)
        end

        private

        def find_current_item playlist
          id = playlist.current_item_id
          item = playlist_item_repository.find id

          return Success item if item

          Failure "Unable to fetch screen. Can't find current playlist item with ID: #{id.inspect}."
        end

        def find_playlist id
          playlist = playlist_repository.find id

          return Success playlist if playlist

          Failure "Unable to fetch screen. Can't find playlist with ID: #{id.inspect}."
        end
      end
    end
  end
end
