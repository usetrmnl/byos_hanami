# frozen_string_literal: true

module Terminus
  module Views
    module Playlists
      # The show view.
      class Show < View
        expose :playlist
        expose :items
      end
    end
  end
end
