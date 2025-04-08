# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      # Rotates and fetches images for rendering on a device.
      class Rotator
        include Deps[:settings]

        def initialize(toucher: Terminus::Screens::Toucher, fetcher: Fetcher.new, **)
          @toucher = toucher
          @fetcher = fetcher
          super(**)
        end

        def call images_uri:, encryption: nil
          fetcher.call(images_uri:, encryption:)
                 .tap { toucher.call settings.screens_root }
        end

        private

        attr_reader :toucher, :fetcher
      end
    end
  end
end
