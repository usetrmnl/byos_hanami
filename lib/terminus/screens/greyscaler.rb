# frozen_string_literal: true

require "mini_magick"

module Terminus
  module Screens
    # Converts image to greyscale BMP image.
    class Greyscaler
      def initialize randomizer: Randomizer, client: MiniMagick
        @randomizer = randomizer
        @client = client
      end

      def call input_path, output_path
        uniquify(output_path).tap { |unique_path| convert input_path, unique_path }
      end

      private

      def convert input_path, output_path
        client.convert do |converter|
          converter << input_path.to_s
          converter.dither << "FloydSteinberg"  # Popular black-n-white dithering algorithm.
          converter.remap << "pattern:gray50"   # Applies 50% grey pattern.
          converter.depth 1                     # Applies 1-bit depth.
          converter.colors 2                    # Enforces black-n-white by limiting to two colors.
          converter.strip                       # Removes all metadata to reduce file size.
          converter << "bmp3:#{output_path}"    # Forces BMP, Version 3 file output.
        end
      end

      def uniquify(path) = Pathname format(path.to_s, name: randomizer.call)

      attr_reader :randomizer, :client
    end
  end
end
