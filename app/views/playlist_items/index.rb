# frozen_string_literal: true

module Terminus
  module Views
    module PlaylistItems
      # The index view.
      class Index < Terminus::View
        expose :playlist_items
      end
    end
  end
end
