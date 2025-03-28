# frozen_string_literal: true

module Terminus
  module Aspects
    module Images
      # Rotates and fetches images for rendering on a device.
      class Rotator
        include Deps[:settings]

        def initialize(toucher: Terminus::Images::Toucher, fetcher: Fetcher.new, **)
          @toucher = toucher
          @fetcher = fetcher
          super(**)
        end

        def call images_uri:, encryption: nil
          toucher.call settings.generated_root
          fetcher.call images_uri:, encryption:
        end

        private

        attr_reader :toucher, :fetcher
      end
    end
  end
end
