# frozen_string_literal: true

module Terminus
  module Aspects
    module Extensions
      # Creates or updates associated screen from Liquid content.
      class ScreenUpserter
        include Deps[
          "aspects.extensions.contextualizer",
          "aspects.extensions.generator",
          "aspects.screens.upserter",
          view: "views.extensions.dynamic"
        ]

        def call extension, model_id: nil, device_id: nil
          screen_variables = load_screen_variables(extension, model_id:, device_id:)

          generator.call(extension, model_id:, device_id:)
                   .fmap { view.call screen_variables:, content: it }
                   .bind do |content|
                     upserter.call model_id:,
                                   device_id:,
                                   content: String.new(content),
                                   **extension.screen_attributes
                   end
        end

        private

        def load_screen_variables extension, model_id:, device_id:
          contextualizer.call(extension, model_id:, device_id:).fetch "screen_variables"
        end
      end
    end
  end
end
