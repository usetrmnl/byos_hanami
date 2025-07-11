# frozen_string_literal: true

require "base64"
require "dry/monads"
require "initable"
require "refinements/pathname"

module Terminus
  module Aspects
    module Screens
      # Fetches latest image for rendering on device screen.
      class Fetcher
        include Initable[types: proc { Terminus::Screens::TYPES.keys }, encryptions: [:base_64]]
        include Deps[:settings, :assets, "aspects.screens.sleeper"]
        include Dry::Monads[:result]

        using Refinements::Pathname

        def call device, encryption: nil
          image_path = build_image_path device

          return default unless image_path

          {filename: image_path.basename.to_s, image_url: image_url(device, image_path, encryption)}
        end

        private

        def build_image_path device
          result = device.asleep? ? sleeper.call(device) : Failure()

          case result
            in Success(path) then path
            else
              settings.screens_root
                      .join(device.slug)
                      .files(supported_types)
                      .reject { it.fnmatch? "*sleep.png" }
                      .max_by(&:mtime)
          end
        end

        def image_url device, image_path, encryption
          if encryptions.include?(encryption) && encryption == :base_64
            "data:image/bmp;base64,#{Base64.strict_encode64 image_path.read}"
          else
            "#{settings.api_uri}/assets/screens/#{device.slug}/#{image_path.basename}"
          end
        end

        def default = {filename: "setup", image_url: assets["setup.svg"].url}

        def supported_types = %(*.{#{types.join ","}})
      end
    end
  end
end
