# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      module Creators
        # Creates screen record with image attachment from unprocessed image URI.
        class Unprocessed
          include Deps[:mini_magick, "aspects.screens.converter", repository: "repositories.screen"]
          include Dry::Monads[:result]

          def initialize(struct: Terminus::Structs::Screen.new, **)
            @struct = struct
            super(**)
          end

          def call(payload) = Pathname.mktmpdir { process payload, it }

          private

          attr_reader :struct

          def process payload, directory
            input_path = Pathname(directory).join "input.png"

            image.open(payload.content)
                 .write(input_path)
                 .then { convert payload.model, input_path, directory.join(payload.filename) }
                 .bind { |path| save payload, path }
          end

          def convert model, input_path, output_path
            converter.call model, input_path, output_path
          end

          def save payload, path
            path.open { |io| struct.upload io, metadata: {"filename" => payload.filename} }
            repository.create_with_image payload, struct
          end

          def image = mini_magick::Image
        end
      end
    end
  end
end
