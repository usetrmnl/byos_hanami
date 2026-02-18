# frozen_string_literal: true

module Terminus
  module Aspects
    module Extensions
      # Creates or updates associated screen from Liquid content.
      class ScreenUpserter
        include Deps[
          "aspects.extensions.renderer",
          "aspects.screens.upserter",
          view: "views.extensions.dynamic"
        ]

        def call extension, model_id
          renderer.call(extension, model_id:)
                  .fmap { view.call body: it }
                  .bind do |content|
                    upserter.call model_id:,
                                  content: String.new(content),
                                  **extension.screen_attributes
                  end
        end
      end
    end
  end
end
