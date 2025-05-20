# frozen_string_literal: true

require "dry/monads"
require "mini_magick"

module Terminus
  module Screens
    # Saves URI as image.
    class URISaver
      include Dry::Monads[:result]

      def initialize client: MiniMagick::Image, greyscaler: Greyscaler.new
        @client = client
        @greyscaler = greyscaler
      end

      def call uri, output_path, dimensions = "800x480"
        Tempfile.create ["uri_saver-", output_path.extname] do |file|
          path = file.path
          save(uri, path, dimensions).bind { greyscaler.call path, output_path }
        end
      end

      private

      attr_reader :client, :greyscaler

      def save uri, path, dimensions
        Success client.open(uri).resize(dimensions).write(path)
      rescue StandardError => error
        Failure error.message
      end
    end
  end
end
