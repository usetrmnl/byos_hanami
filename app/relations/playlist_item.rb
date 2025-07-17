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
        calculation = "position = CASE " \
                      "WHEN ? >= (SELECT MAX(position) FROM playlist_item) " \
                      "THEN (SELECT MIN(position) FROM playlist_item) " \
                      "ELSE ? + 1 " \
                      "END"

        where(playlist_id:).where(Sequel.lit(calculation, after, after)).one
      end
    end
  end
end
