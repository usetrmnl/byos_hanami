# frozen_string_literal: true

require "base64"
require "dry/monads"

module Terminus
  module Aspects
    module Screens
      module Creators
        # Saves Base64 encoded content as image to temporary file path for optional processing.
        class EncodedPath
          include Deps["aspects.screens.converter"]
          include Dry::Monads[:result]

          def initialize(decoder: Base64, **)
            @decoder = decoder
            super(**)
          end

          def call(mold, &) = Pathname.mktmpdir { process mold, it, & }

          private

          attr_reader :decoder

          def process mold, directory
            mold.input_path = directory.join "input.png"
            mold.output_path = directory.join mold.filename

            decode_input(mold).bind { converter.call mold }
                              .bind { |path| block_given? ? yield(path) : path }
          end

          def decode_input mold
            mold.input_path.binwrite decoder.strict_decode64(mold.content)
            Success mold.input_path
          rescue ArgumentError => error
            Failure "Invalid Base64 data: #{error.message}"
          end
        end
      end
    end
  end
end
