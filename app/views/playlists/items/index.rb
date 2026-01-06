# frozen_string_literal: true

module Terminus
  module Views
    module Playlists
      module Items
        # The index view.
        class Index < View
          expose :playlist_id
          expose :items
          expose :query
        end
      end
    end
  end
end
