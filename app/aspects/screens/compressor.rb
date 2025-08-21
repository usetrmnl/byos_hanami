# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Compresses BMPs as PNGs, otherwise skips.
      class Compressor
        include Deps[:mini_magick]
        include Dry::Monads[:result]

        def call input_path
          return Success input_path unless input_path.extname == ".bmp"

          output_path = input_path.sub_ext ".png"

          convert input_path, output_path
          Success output_path
        rescue MiniMagick::Error => error
          Failure error.message
        end

        private

        def convert input_path, output_path
          mini_magick.convert do |converter|
            converter << input_path.to_s
            converter << output_path.to_s
          end
        end
      end
    end
  end
end
