# frozen_string_literal: true

module Terminus
  module Views
    module Playlists
      # The show view.
      class Show < Terminus::View
        expose :playlist
        expose :items
      end
    end
  end
end
