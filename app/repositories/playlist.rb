# frozen_string_literal: true

module Terminus
  module Repositories
    # The playlist repository.
    class Playlist < DB::Repository[:playlist]
      commands :create, update: :by_pk, delete: :by_pk

      def all
        playlist.order { created_at.asc }
                .to_a
      end

      def all_by(**)
        playlist.where(**)
                .order { created_at.asc }
                .to_a
      end

      def find(id) = (with_current_item.by_pk(id).one if id)

      def find_by(**) = with_current_item.where(**).one

      private

      def with_current_item = playlist.combine :current_item
    end
  end
end
