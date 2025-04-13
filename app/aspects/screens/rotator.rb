# frozen_string_literal: true

require "initable"

module Terminus
  module Aspects
    module Screens
      # Rotates and fetches images for rendering on a device.
      class Rotator
        include Deps[:settings, "aspects.screens.fetcher"]
        include Initable[toucher: proc { Terminus::Screens::Toucher }]

        def call slug, encryption: nil
          fetcher.call(slug, encryption:).tap { toucher.call settings.screens_root.join(slug) }
        end
      end
    end
  end
end
