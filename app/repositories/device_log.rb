# frozen_string_literal: true

module Terminus
  module Repositories
    # The device log repository.
    class DeviceLog < DB::Repository[:device_log]
      commands :create, delete: :by_pk

      commands update: :by_pk,
               use: :timestamps,
               plugins_options: {timestamps: {timestamps: :updated_at}}

      def all
        device_log.combine(:device)
                  .order { created_at.desc }
                  .to_a
      end

      def find(id) = (device_log.combine(:device).by_pk(id).one if id)

      def delete_by_device(device_id, id) = device_log.where(device_id:, id:).delete

      def delete_all_by_device(device_id) = device_log.where(device_id:).command(:delete).call

      def search(key, value, **)
        device_log.where(**)
                  .where(Sequel.ilike(key, "%#{value}%"))
                  .order { created_at.asc }
                  .to_a
      end

      def where(**)
        device_log.where(**)
                  .order { created_at.desc }
                  .to_a
      end
    end
  end
end
