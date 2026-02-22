# frozen_string_literal: true

require "dry/monads"
require "pipeable"

module Terminus
  module Aspects
    module Devices
      # Updates device based on firmware header information.
      class Synchronizer
        include Deps[
          :settings,
          firmware_parser: "aspects.firmware.headers.parser",
          repository: "repositories.device"
        ]
        include Pipeable
        include Dry::Monads[:result]

        def call(headers) = pipe firmware_parser.call(headers), :update

        private

        def update result
          result.bind do |payload|
            device = repository.update_by_mac_address payload.mac_address,
                                                      **payload.device_attributes
            device ? Success(device) : Failure("Unable to find device by MAC address.")
          end
        end
      end
    end
  end
end
