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

      def next_item playlist_id:, after:
        scope = combine(:screen).where(playlist_id:).order :position

        next_or_previous = scope.where { position > after }
                                .first

        next_or_previous || scope.first
      end
    end
  end
end
