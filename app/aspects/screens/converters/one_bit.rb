# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      module Converters
        # Converts to 1-bit PNG image.
        class OneBit
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
              converter.dither << "FloydSteinberg"
              converter.remap << "pattern:gray50"
              converter.depth model.bit_depth
              converter.colors model.colors
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
