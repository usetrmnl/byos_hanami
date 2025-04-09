# frozen_string_literal: true

require "initable"

module Terminus
  module Aspects
    module Screens
      # Rotates and fetches images for rendering on a device.
      class Rotator
        include Deps[:settings, "aspects.screens.fetcher"]
        include Initable[toucher: proc { Terminus::Screens::Toucher }]

        def call images_uri:, encryption: nil
          fetcher.call(images_uri:, encryption:)
                 .tap { toucher.call settings.screens_root }
        end
      end
    end
  end
end
