# frozen_string_literal: true

require "base64"
require "dry/monads"
require "refinements/struct"

module Terminus
  module Aspects
    module Screens
      module Upserters
        # Creates screen record with image attachment from decoded image data.
        class Encoded
          include Dry::Monads[:result]
          include Deps["aspects.screens.converter", repository: "repositories.screen"]
          include Dry::Monads[:result]

          using Refinements::Struct

          def initialize(decoder: Base64, struct: Terminus::Structs::Screen.new, **)
            @decoder = decoder
            @struct = struct
            super(**)
          end

          def call(mold) = Pathname.mktmpdir { process mold, it }

          private

          attr_reader :decoder, :struct

          def process mold, directory
            mold.with! input_path: Pathname(directory).join("input.png"),
                       output_path: directory.join(mold.filename)

            mold.input_path
                .binwrite(decoder.strict_decode64(mold.content))
                .then { converter.call mold }
                .bind { |path| save mold, path }
          end

          def save(mold, path) = Success repository.upsert_with_image(path, mold, struct)
        end
      end
    end
  end
end
