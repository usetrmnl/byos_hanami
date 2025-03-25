# frozen_string_literal: true

module Terminus
  module Repositories
    # The device log repository.
    class DeviceLog < DB::Repository[:device_logs]
      commands :create, update: :by_pk, delete: :by_pk

      def all
        device_logs.combine(:device)
                   .order { created_at.asc }
                   .to_a
      end

      def find(id) = (device_logs.combine(:device).by_pk(id).one if id)
    end
  end
end
