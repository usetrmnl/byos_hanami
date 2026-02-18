# frozen_string_literal: true

require "refinements/hash"

module Terminus
  module Aspects
    module Extensions
      # Assembles the Liquid context for rendering screens.
      class Contextualizer
        include Deps["aspects.models.finder", sensor_repository: "repositories.device_sensor"]

        using Refinements::Hash

        def call extension, model_id: nil, device_id: nil
          {
            "extension" => extension.liquid_attributes,
            "model" => liquify_model(model_id, device_id),
            "sensors" => load_sensors(device_id)
          }
        end

        private

        def liquify_model model_id, device_id
          model = finder.call(model_id:, device_id:).value_or(nil)
          model.liquid_attributes.stringify_keys! if model
        end

        def load_sensors(device_id) = sensor_repository.where(device_id:).map(&:liquid_attributes)
      end
    end
  end
end
