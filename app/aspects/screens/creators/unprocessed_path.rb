# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      module Creators
        # Saves unprocessed image from URI to temporary file path with conversion.
        class UnprocessedPath
          include Deps[:mini_magick, "aspects.screens.converter"]
          include Dry::Monads[:result]

          def call(mold, &) = Pathname.mktmpdir { process mold, it, & }

          private

          def process mold, directory
            mold.input_path = directory.join "input.png"
            mold.output_path = directory.join mold.filename

            fetch_input(mold).bind { converter.call mold }
                             .bind { |path| block_given? ? yield(path) : path }
          end

          def fetch_input mold
            mini_magick::Image.open(mold.content).write mold.input_path
            Success mold.input_path
          rescue StandardError => error
            Failure "Unable to fetch image: #{error.message}"
          end
        end
      end
    end
  end
end
