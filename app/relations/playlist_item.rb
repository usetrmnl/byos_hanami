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

      def next_item after:, playlist_id:
        scope = where(playlist_id:)

        next_or_previous = scope.where { position > after }
                                .order(:position)
                                .first

        next_or_previous || scope.order(:position).first
      end
    end
  end
end
