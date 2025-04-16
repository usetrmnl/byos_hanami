# frozen_string_literal: true

require "base64"
require "initable"
require "refinements/pathname"

module Terminus
  module Aspects
    module Screens
      # Fetches latest image for rendering on device screen.
      class Fetcher
        include Initable[encryptions: [:base_64]]
        include Deps[:settings, :assets]

        using Refinements::Pathname

        def call slug, encryption: nil
          image_path = settings.screens_root.join(slug).files("*.bmp").max_by(&:mtime)

          return default unless image_path

          {filename: image_path.basename.to_s, image_url: image_url(slug, image_path, encryption)}
        end

        private

        def image_url slug, image_path, encryption
          if encryptions.include?(encryption) && encryption == :base_64
            "data:image/bmp;base64,#{Base64.strict_encode64 image_path.read}"
          else
            "#{settings.api_uri}/assets/screens/#{slug}/#{image_path.basename}"
          end
        end

        def default = {filename: "empty_state", image_url: "#{settings.api_uri}/assets/trmnl.svg"}
      end
    end
  end
end
