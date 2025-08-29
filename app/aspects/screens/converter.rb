# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Converts to greyscale image based on MIME Type.
      class Converter
        include Deps["aspects.screens.converters.bmp", "aspects.screens.converters.png"]
        include Dry::Monads[:result]

        def call mold
          case mold
            in mime_type: "image/bmp" then bmp.call mold
            in mime_type: "image/png" then png.call mold
            else Failure "Unsupported MIME Type: #{mold.mime_type}."
          end
        end
      end
    end
  end
end
