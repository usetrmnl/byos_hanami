# frozen_string_literal: true

require "core"

module Terminus
  module Aspects
    module Extensions
      # Assembles the Liquid context for rendering screens.
      class Contextualizer
        include Deps[
          "aspects.models.finder",
          device_repository: "repositories.device",
          sensor_repository: "repositories.device_sensor"
        ]

        def call extension, model_id: nil, device_id: nil
          model = finder.call(model_id:, device_id:).value_or(nil)

          {
            "extension" => extension.liquid_attributes.merge!(
              "css_classes" => (model.css_classes.join " " if model),
              "device" => load_device(device_id)
            ),
            "screen_variables" => (model.css_variables.join "\n" if model),
            "sensors" => load_sensors(device_id)
          }
        end

        private

        def load_device id
          device = device_repository.find id
          device ? device.liquid_attributes : Core::EMPTY_HASH
        end

        def load_sensors(device_id) = sensor_repository.where(device_id:).map(&:liquid_attributes)
      end
    end
  end
end
