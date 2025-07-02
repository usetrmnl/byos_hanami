# frozen_string_literal: true

module Terminus
  module Repositories
    # The device repository.
    class Device < DB::Repository[:devices]
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

      def mirror_playlist ids, playlist_id
        devices.update playlist_id: Sequel.case({{id: ids} => playlist_id}, nil)
      end

      def update_by_mac_address(value, **attributes)
        device = find_by mac_address: value

        return device if attributes.empty?
        return unless device

        update device.id, **attributes
      end

      private

      def with_associations = devices.combine :model, :playlist
    end
  end
end
