# frozen_string_literal: true

require "base64"
require "dry/monads"
require "mini_magick"

module Terminus
  module Screens
    module Savers
      # Saves encoded content as a decoded and processed image.
      class Encoded
        include Dry::Monads[:result]

        def initialize client: MiniMagick::Image, decoder: Base64, greyscaler: Greyscaler.new
          @client = client
          @decoder = decoder
          @greyscaler = greyscaler
        end

        def call content, output_path, dimensions = "800x480"
          Tempfile.create ["uri_saver-", output_path.extname] do |file|
            path = file.path
            save(content, path, dimensions).bind { greyscaler.call path, output_path }
          end
        end

        private

        attr_reader :client, :decoder, :greyscaler

        def save content, path, dimensions
          Pathname(path).binwrite decoder.strict_decode64(content)
          Success client.open(path).resize(dimensions).write(path)
        rescue StandardError => error
          Failure error.message
        end
      end
    end
  end
end
