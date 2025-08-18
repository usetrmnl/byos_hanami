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

          def call model, input_path, output_path
            color_mapper.call(model.bit_depth)
                        .fmap { |path| convert model, input_path, path, output_path }
                        .fmap { output_path }
          rescue MiniMagick::Error => error then Failure error.message
          end

          private

          def convert model, input_path, color_map_path, output_path
            mini_magick.convert do |converter|
              converter << input_path.to_s
              converter.define "png:bit-depth=#{model.bit_depth}"
              converter.define "png:color-type=0"
              converter.rotate model.rotation if model.rotatable?
              converter.resize "#{model.dimensions}!"
              converter.crop model.crop if model.cropable?
              converter.dither << "FloydSteinberg"
              converter.remap << color_map_path.to_s
              converter.strip
              converter << output_path
            end
          end
        end
      end
    end
  end
end
