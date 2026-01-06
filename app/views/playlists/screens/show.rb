# frozen_string_literal: true

require "dry/core"

module Terminus
  module Views
    module Playlists
      module Screens
        # The show view.
        class Show < View
          expose :playlist
          expose :before
          expose :current
          expose :after
          expose(:index) { |playlist:, current:| playlist.screens.index current }
          expose(:total) { |playlist:| playlist.screens.size - 1 }
          expose(:status) { |index, total| "Slide #{index + 1} of #{total + 1}" if index && total }
        end
      end
    end
  end
end
