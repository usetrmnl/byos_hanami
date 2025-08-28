# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      module Converters
        # Converts to PNG image.
        class PNG
          include Deps[:mini_magick, "aspects.screens.color_mapper"]
          include Dry::Monads[:result]

          def call mold
            color_mapper.call(mold.bit_depth)
                        .fmap { |path| convert mold, path }
                        .fmap { mold.output_path }
          rescue MiniMagick::Error => error then Failure error.message
          end

          private

          def convert mold, color_map_path
            mini_magick.convert do |converter|
              converter << mold.input_path.to_s
              converter.define "png:bit-depth=#{mold.bit_depth}"
              converter.define "png:color-type=0"
              converter.rotate mold.rotation if mold.rotatable?
              converter.resize "#{mold.dimensions}!"
              converter.crop mold.crop if mold.cropable?
              converter.type "Grayscale"
              converter.dither "FloydSteinberg"
              converter.remap color_map_path.to_s if color_map_path.exist?
              converter.strip
              converter << mold.output_path
            end
          end
        end
      end
    end
  end
end
