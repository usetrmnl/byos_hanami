# frozen_string_literal: true

module Terminus
  module Repositories
    # The playlist repository.
    class PlaylistItem < DB::Repository[:playlist_item]
      commands :create, delete: :by_pk

      commands update: :by_pk,
               use: :timestamps,
               plugins_options: {timestamps: {timestamps: :updated_at}}

      def all
        with_associations.order { [playlist_id, position.asc] }
                         .to_a
      end

      def create_with_position(playlist_id:, offset: 1, **)
        playlist_item.transaction do
          position = playlist_item.where(playlist_id:).max(:position).to_i + offset

          playlist_item.command(:create)
                       .call(playlist_id:, position:, **)
                       .then { find it.id }
        end
      end

      def delete_all(**) = playlist_item.where(**).delete

      def find(id) = (with_associations.by_pk(id).one if id)

      def find_by(**) = with_associations.where(**).one

      def previous(playlist_id:, position:) = playlist_item.previous(playlist_id:, position:)

      def subsequent(playlist_id:, position:) = playlist_item.subsequent(playlist_id:, position:)

      def first playlist_id:
        playlist_item.combine(:screen)
                     .where(playlist_id:)
                     .order { position.asc }
                     .first
      end

      def last playlist_id:
        playlist_item.combine(:screen)
                     .where(playlist_id:)
                     .order { position.desc }
                     .first
      end

      def where(**)
        with_associations.where(**)
                         .order { [playlist_id, position.asc] }
                         .to_a
      end

      private

      def with_associations = playlist_item.combine :playlist, :screen
    end
  end
end
