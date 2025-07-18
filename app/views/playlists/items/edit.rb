# frozen_string_literal: true

module Terminus
  module Views
    module Playlists
      module Items
        # The edit view.
        class Edit < Terminus::View
          expose :screen_options, decorate: false
          expose :item
          expose :fields, default: Dry::Core::EMPTY_HASH
          expose :errors, default: Dry::Core::EMPTY_HASH
        end
      end
    end
  end
end
