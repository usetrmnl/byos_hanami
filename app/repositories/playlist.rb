# frozen_string_literal: true

module Terminus
  module Repositories
    # The playlist repository.
    class Playlist < DB::Repository[:playlist]
      commands :create, delete: :by_pk

      commands update: :by_pk,
               use: :timestamps,
               plugins_options: {timestamps: {timestamps: :updated_at}}

      def all
        with_current_item.order { created_at.asc }
                         .to_a
      end

      def find(id) = (with_current_item.by_pk(id).one if id)

      def find_by(**) = with_current_item.where(**).one

      def search key, value
        playlist.where(Sequel.ilike(key, "%#{value}%"))
                .order { created_at.asc }
                .to_a
      end

      def update_current_item id, item
        record = find id
        record && item ? update(id, current_item_id: item.id) : record
      end

      def where(**)
        playlist.where(**)
                .order { created_at.asc }
                .to_a
      end

      private

      def with_current_item = playlist.combine current_item: :screen
    end
  end
end
