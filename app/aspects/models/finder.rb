# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Models
      # Finds model record by model or device ID.
      class Finder
        include Deps[
          model_repository: "repositories.model",
          device_repository: "repositories.device"
        ]

        include Dry::Monads[:result]

        def call model_id: nil, device_id: nil
          model = find model_id, device_id

          return Success model if model

          Failure "Unable to find model for model ID (#{model_id.inspect}) or " \
                  "device ID (#{device_id.inspect})."
        end

        private

        def find model_id, device_id
          return model_repository.find model_id unless device_id

          device = device_repository.find device_id
          model_repository.find device.model_id if device
        end
      end
    end
  end
end
