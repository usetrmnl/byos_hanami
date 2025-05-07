# frozen_string_literal: true

module Terminus
  module Repositories
    # The device repository.
    class Device < DB::Repository[:devices]
      commands :create, update: :by_pk, delete: :by_pk

      def all
        devices.order { created_at.asc }
               .to_a
      end

      def all_by_label value
        devices.where { label.ilike "%#{value}%" }
               .order { created_at.asc }
               .to_a
      end

      def find(id) = (devices.by_pk(id).one if id)

      def find_by_api_key(value) = devices.where(api_key: value.to_s).one

      def find_by_mac_address(value) = devices.where(mac_address: value.to_s).one

      # :reek:FeatureEnvy
      def update_by_mac_address(value, **attributes)
        relation = devices.where mac_address: value.to_s

        return relation.one if attributes.empty?

        relation.command(:update).call(**attributes)
      end
    end
  end
end
