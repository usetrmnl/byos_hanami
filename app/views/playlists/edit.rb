# frozen_string_literal: true

module Terminus
  module Views
    module Playlists
      # The edit view.
      class Edit < Terminus::View
        expose :playlist
        expose :items, default: Dry::Core::EMPTY_ARRAY
        expose :fields, default: Dry::Core::EMPTY_HASH
        expose :errors, default: Dry::Core::EMPTY_HASH
      end
    end
  end
end
