# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      module Converters
        # Converts to BMP image for any bit depth and color.
        class BMP
          include Deps[:mini_magick]
          include Dry::Monads[:result]

          def call mold
            convert mold
            Success mold.output_path
          rescue MiniMagick::Error => error
            Failure error.message
          end

          private

          def convert mold
            mini_magick.convert do |converter|
              converter << mold.input_path.to_s
              converter.colors mold.colors
              converter.depth mold.bit_depth
              converter.monochrome
              converter.resize "#{mold.dimensions}!"
              converter.strip
              converter << "bmp3:#{mold.output_path}"
            end
          end
        end
      end
    end
  end
end
