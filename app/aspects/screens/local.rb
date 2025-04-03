# frozen_string_literal: true

require "base64"
require "initable"
require "refinements/pathname"

module Terminus
  module Aspects
    module Screens
      # Fetches image for rendering on device screen.
      class Local
        include Initable[encryptions: [:base_64]]
        include Deps[:settings, :assets]

        using Refinements::Pathname

        def call images_uri:, encryption: nil
          last_generated_image(images_uri, encryption) || default
        end

        private

        # :reek:TooManyStatements
        def last_generated_image images_uri, encryption
          image_path = root_path.files("*.bmp").max_by(&:ctime)

          return unless image_path

          filename = image_path.basename.to_s

          image_url = if encryptable? encryption
                        "data:image/bmp;base64,#{Base64.strict_encode64 image_path.read}"
                      else
                        "#{images_uri}/generated/#{filename}"
                      end

          {filename:, image_url:}
        end

        def encryptable?(value) = encryptions.include?(value) && value == :base_64

        def root_path = Pathname settings.generated_root

        def default = {filename: "empty_state", image_url: assets["setup.bmp"].url}
      end
    end
  end
end
