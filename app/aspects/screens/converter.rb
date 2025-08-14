# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Converts image to greyscale BMP image.
      class Converter
        include Deps[
          "aspects.screens.converters.bitmap",
          "aspects.screens.converters.one_bit",
          "aspects.screens.converters.two_bit"
        ]
        include Dry::Monads[:result]

        def call model, input_path, output_path
          case model
            in mime_type: "image/bmp", bit_depth: 1
              bitmap.call model, input_path, output_path
            in mime_type: "image/png", bit_depth: 1
              one_bit.call model, input_path, output_path
            in mime_type: "image/png", bit_depth: 2
              two_bit.call model, input_path, output_path
            else Failure "Unable to convert image. Unsupported model: #{model.id}."
          end
        end
      end
    end
  end
end
