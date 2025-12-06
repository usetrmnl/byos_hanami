# frozen_string_literal: true

module Terminus
  module Views
    module Playlists
      module Screens
        # The show view.
        class Show < Terminus::View
          expose :playlist
          expose :before
          expose :current
          expose :after
        end
      end
    end
  end
end
