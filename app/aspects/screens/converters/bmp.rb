# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      module Converters
        # Converts to 1-bit BMP image.
        class BMP
          include Deps[:mini_magick]
          include Dry::Monads[:result]

          def call model, input_path, output_path
            convert model, input_path, output_path
            Success output_path
          rescue MiniMagick::Error => error
            Failure error.message
          end

          private

          def convert model, input_path, output_path
            mini_magick.convert do |converter|
              converter << input_path.to_s
              converter.colors model.colors
              converter.depth model.bit_depth
              converter.monochrome
              converter.resize "#{model.dimensions}!"
              converter.strip
              converter << "bmp3:#{output_path}"
            end
          end
        end
      end
    end
  end
end
