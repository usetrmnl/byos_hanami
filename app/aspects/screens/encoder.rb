# frozen_string_literal: true

require "base64"
require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Dynamically encodes screen image as Base64 data URI or answers unencoded URI.
      class Encoder
        include Deps[:settings]
        include Initable[client: Base64, encryptions: [:base_64]]
        include Dry::Monads[:result]

        def call screen, encryption: nil
          if encryptions.include? encryption
            payload_for screen
          else
            Success filename: screen.image_name_with_checksum,
                    image_url: screen.image_uri(host: settings.api_uri)
          end
        end

        private

        def payload_for screen
          Success filename: screen.image_name_with_checksum,
                  image_url: "data:#{screen.mime_type};base64,#{content_for screen}"
        end

        def content_for(screen) = client.strict_encode64 screen.image_open(&:read)
      end
    end
  end
end
