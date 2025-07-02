# frozen_string_literal: true

module Terminus
  module Views
    module Playlists
      module Mirror
        # The edit view.
        class Edit < Terminus::View
          expose :playlist
          expose :devices
        end
      end
    end
  end
end
