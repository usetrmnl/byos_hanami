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

      def previous playlist_id:, position:
        scope = combine(:screen).where(playlist_id:).order :position
        closest(scope, :<, position) || scope.first
      end

      def subsequent playlist_id:, position:
        scope = combine(:screen).where(playlist_id:).order :position
        closest(scope, :>, position) || scope.first
      end

      private

      def closest scope, operator, value
        scope.where { position.public_send operator, value }
             .first
      end
    end
  end
end
