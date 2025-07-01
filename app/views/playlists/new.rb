# frozen_string_literal: true

module Terminus
  module Views
    module Playlists
      # The new view.
      class New < Terminus::View
        expose :playlist
        expose :fields, default: Dry::Core::EMPTY_HASH
        expose :errors, default: Dry::Core::EMPTY_HASH
      end
    end
  end
end
