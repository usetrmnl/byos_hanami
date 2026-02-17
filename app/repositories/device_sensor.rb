# frozen_string_literal: true

module Terminus
  module Repositories
    # The device sensor repository.
    class DeviceSensor < DB::Repository[:device_sensor]
      commands :create, delete: :by_pk

      def all
        with_associations.order { created_at.desc }
                         .to_a
      end

      def find(id) = (with_associations.by_pk(id).one if id)

      def find_by(**) = with_associations.where(**).one

      def search(key, value, **)
        with_associations.where(**)
                         .where(Sequel.ilike(key, "%#{value}%"))
                         .order { created_at.asc }
                         .to_a
      end

      def where(**)
        with_associations.where(**)
                         .order { created_at.desc }
                         .to_a
      end

      private

      def with_associations = device_sensor.combine :device
    end
  end
end
