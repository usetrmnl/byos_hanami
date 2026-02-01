# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      module Creators
        # Saves preprocessed image from URI to temporary file path for optional processing.
        class PreprocessedPath
          include Deps[:mini_magick]
          include Dry::Monads[:result]

          def call(mold, &) = Pathname.mktmpdir { process mold, it, & }

          private

          def process mold, directory
            path = directory.join mold.filename

            fetch_image(mold, path).bind { |result| block_given? ? yield(result) : result }
          end

          def fetch_image mold, path
            mini_magick::Image.open(mold.content).write path
            Success path
          rescue StandardError => error
            Failure "Unable to fetch image: #{error.message}"
          end
        end
      end
    end
  end
end
