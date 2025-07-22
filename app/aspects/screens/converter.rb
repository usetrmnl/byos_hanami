# frozen_string_literal: true

require "dry/monads"
require "initable"
require "mini_magick"
require "refinements/array"

module Terminus
  module Aspects
    module Screens
      # Converts image to greyscale BMP image.
      # :reek:DataClump
      class Converter
        include Initable[types: TYPES, client: MiniMagick]
        include Dry::Monads[:result]

        using Refinements::Array

        def call model, input_path, output_path
          output_path.extname.delete_prefix "."

          typed_path_for(output_path, model.mime_type).bind do |typed_output_path|
            process model, input_path, typed_output_path, output_path
          end
        end

        private

        # rubocop:todo Metrics/ParameterLists
        def process model, input_path, typed_output_path, output_path
          convert model, input_path, typed_output_path
          Success output_path
        rescue MiniMagick::Error => error
          Failure error.message
        end
        # rubocop:enable Metrics/ParameterLists

        def convert model, input_path, typed_output_path
          client.convert do |converter|
            converter << input_path.to_s
            converter.dither << "FloydSteinberg"     # Popular black-n-white dithering algorithm.
            converter.remap << "pattern:gray50"
            converter.depth model.bit_depth
            converter.colors model.colors
            converter.strip
            converter.resize "#{model.dimensions}!"
            converter << typed_output_path           # Saves to path using specific image type.
          end
        end

        def typed_path_for path, extension
          type = types[extension]

          return Success "#{type}:#{path}" if type

          Failure %(Invalid MIME Type: #{extension.inspect}. Use: #{types.keys.to_usage "or"}.)
        end
      end
    end
  end
end
