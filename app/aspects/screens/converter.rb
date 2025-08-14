# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Converts image to greyscale BMP image.
      class Converter
        include Deps["aspects.screens.converters.bmp", "aspects.screens.converters.png"]
        include Dry::Monads[:result]

        def call model, input_path, output_path
          case model
            in mime_type: "image/bmp" then bmp.call model, input_path, output_path
            in mime_type: "image/png" then png.call model, input_path, output_path
            else Failure "Unsupported MIME Type for model: #{model.id}."
          end
        end
      end
    end
  end
end
