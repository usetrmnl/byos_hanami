# frozen_string_literal: true

module Terminus
  module Repositories
    # The device repository.
    class Device < DB::Repository[:devices]
      commands :create, update: :by_pk, delete: :by_pk

      def find(id) = devices.by_pk(id).one

      def find_by_api_key value
        devices.where { api_key.ilike "%#{value}%" }
               .one
      end

      def find_by_mac_address value
        devices.where { mac_address.ilike "%#{value}%" }
               .one
      end

      def all
        devices.order { created_at.asc }
               .to_a
      end
    end
  end
end
