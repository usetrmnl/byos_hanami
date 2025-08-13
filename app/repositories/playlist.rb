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
        playlist.order { created_at.asc }
                .to_a
      end

      def find(id) = (with_current_item.by_pk(id).one if id)

      def find_by(**) = with_current_item.where(**).one

      def update_current_item id, item_id
        playlist.transaction do
          record = find id
          record.current_item_id ? record : update(id, current_item_id: item_id)
        end
      end

      def where(**)
        playlist.where(**)
                .order { created_at.asc }
                .to_a
      end

      private

      def with_current_item = playlist.combine :current_item
    end
  end
end
