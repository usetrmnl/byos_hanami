# frozen_string_literal: true

module Terminus
  module Repositories
    # The playlist repository.
    class PlaylistItem < DB::Repository[:playlist_item]
      commands :create, update: :by_pk, delete: :by_pk

      def all
        with_associations.order { created_at.asc }
                         .to_a
      end

      def all_by(**)
        with_associations.where(**)
                         .order { created_at.asc }
                         .to_a
      end

      def find(id) = (with_associations.by_pk(id).one if id)

      def find_by(**) = with_associations.where(**).one

      private

      def with_associations = playlist_item.combine :playlist, :screen
    end
  end
end
