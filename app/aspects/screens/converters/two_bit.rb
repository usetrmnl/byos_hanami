# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      module Converters
        # Converts to 2-bit PNG image.
        class TwoBit
          include Deps[:mini_magick, "aspects.screens.color_mapper"]
          include Dry::Monads[:result]

          def call model, input_path, output_path
            color_mapper.call
                        .fmap { |path| convert model, input_path, path, output_path }
                        .fmap { output_path }
          rescue MiniMagick::Error => error
            Failure error.message
          end

          private

          def convert model, input_path, color_map_path, output_path
            mini_magick.convert do |converter|
              converter << input_path.to_s
              converter.dither << "FloydSteinberg"
              converter.remap << color_map_path.to_s
              converter.define "png:bit-depth=#{model.bit_depth}"
              converter.define "png:color-type=0"
              converter.strip
              converter.resize "#{model.dimensions}!"
              converter << output_path
            end
          end
        end
      end
    end
  end
end
