# frozen_string_literal: true

require "dry/monads"
require "mini_magick"
require "refinements/array"

module Terminus
  module Screens
    # Converts image to greyscale BMP image.
    class Greyscaler
      include Dry::Monads[:result]

      using Refinements::Array

      def initialize types: TYPES, randomizer: Randomizer, client: MiniMagick
        @types = types
        @randomizer = randomizer
        @client = client
      end

      def call input_path, output_path
        formatted_output_path = uniquify output_path
        extension = output_path.extname.delete_prefix "."

        typed_path_for(formatted_output_path, extension).bind do |typed_output_path|
          process input_path, typed_output_path, formatted_output_path
        end
      end

      private

      def process input_path, typed_output_path, output_path
        convert input_path, typed_output_path
        Success output_path
      rescue MiniMagick::Error => error
        Failure error.message
      end

      def convert input_path, typed_output_path
        client.convert do |converter|
          converter << input_path.to_s
          converter.dither << "FloydSteinberg"  # Popular black-n-white dithering algorithm.
          converter.remap << "pattern:gray50"   # Applies 50% grey pattern.
          converter.depth 1                     # Applies 1-bit depth.
          converter.colors 2                    # Enforces black-n-white by limiting to two colors.
          converter.strip                       # Removes all metadata to reduce file size.
          converter << typed_output_path        # Saves to path using specific image type.
        end
      end

      def uniquify(path) = Pathname format(path.to_s, name: randomizer.call)

      def typed_path_for path, extension
        return type_error extension unless types.include? extension

        Success "#{extension == "bmp" ? "bmp3" : extension}:#{path}"
      end

      def type_error value
        Failure %(Invalid image type: #{value.inspect}. Use: #{types.to_usage "or"}.)
      end

      attr_reader :types, :randomizer, :client
    end
  end
end
