# frozen_string_literal: true

module Terminus
  module Repositories
    # The device log repository.
    class DeviceLog < DB::Repository[:device_logs]
      commands :create, delete: :by_pk

      commands update: :by_pk,
               use: :timestamps,
               plugins_options: {timestamps: {timestamps: :updated_at}}

      def all
        device_logs.combine(:device)
                   .order { created_at.desc }
                   .to_a
      end

      def all_by_message device_id, value
        device_logs.where(device_id:)
                   .where { message.ilike "%#{value}%" }
                   .order { created_at.desc }
                   .to_a
      end

      def find(id) = (device_logs.combine(:device).by_pk(id).one if id)

      def delete_by_device(device_id, id) = device_logs.where(device_id:, id:).delete

      def delete_all_by_device(device_id) = device_logs.where(device_id:).command(:delete).call

      def search(key, value, **)
        device_logs.where(**)
                   .where(Sequel.ilike(key, "%#{value}%"))
                   .order { created_at.asc }
                   .to_a
      end

      def where(**)
        device_logs.where(**)
                   .order { created_at.desc }
                   .to_a
      end
    end
  end
end
