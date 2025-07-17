# frozen_string_literal: true

module Terminus
  module Relations
    # The playlist item relation.
    class PlaylistItem < DB::Relation
      schema :playlist_item, infer: true do
        associations do
          belongs_to :playlist, relation: :playlist
          belongs_to :screen, relation: :screen
        end
      end
    end
  end
end
