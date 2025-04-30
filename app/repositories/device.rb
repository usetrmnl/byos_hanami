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

      def find(id) = (devices.by_pk(id).one if id)

      def find_all_by_label value
        devices.where { label.ilike "%#{value}%" }
               .order { created_at.asc }
               .to_a
      end

      def find_by_api_key value
        return unless value

        devices.where { api_key.ilike "%#{value}%" }
               .one
      end

      def find_by_mac_address value
        return unless value

        devices.where { mac_address.ilike "%#{value}%" }
               .one
      end

      def update_by_api_key(value, **attributes)
        relation = devices.where { api_key.ilike "%#{value}%" }

        return relation.one if attributes.empty?

        relation.command(:update).call(**attributes)
      end
    end
  end
end
