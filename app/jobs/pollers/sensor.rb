# auto_register: false
# frozen_string_literal: true

module Terminus
  module Jobs
    module Pollers
      # Polls server sensor data if available.
      class Sensor < Base
        include Deps["aspects.devices.sensors.synchronizer"]

        sidekiq_options queue: "within_1_minute"

        def perform = synchronizer.call
      end
    end
  end
end
