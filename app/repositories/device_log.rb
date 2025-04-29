# frozen_string_literal: true

module Terminus
  module Repositories
    # The device log repository.
    class DeviceLog < DB::Repository[:device_logs]
      commands :create, update: :by_pk, delete: :by_pk

      def all
        device_logs.combine(:device)
                   .order { created_at.desc }
                   .to_a
      end

      def all_by_device device_id
        device_logs.where(device_id:)
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

      def delete_by_device(device_id, id) = device_logs.where(device_id: device_id, id: id).delete
    end
  end
end
