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

      def ordered = select_append(:position).order :position

      def previous playlist_id:, before:
        scope = combine(:screen).where(playlist_id:).order :position
        closest(scope, :<, before) || scope.first
      end

      def next_item playlist_id:, after:
        scope = combine(:screen).where(playlist_id:).order :position
        closest(scope, :>, after) || scope.first
      end

      private

      def closest scope, operator, value
        scope.where { position.public_send operator, value }
             .first
      end
    end
  end
end
