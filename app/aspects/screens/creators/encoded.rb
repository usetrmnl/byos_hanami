# frozen_string_literal: true

require "base64"
require "dry/monads"

module Terminus
  module Aspects
    module Screens
      module Creators
        # Creates screen record with image attachment from decoded image data.
        class Encoded
          include Dry::Monads[:result]
          include Deps["aspects.screens.converter", repository: "repositories.screen"]

          def initialize(decoder: Base64, struct: Terminus::Structs::Screen.new, **)
            @decoder = decoder
            @struct = struct
            super(**)
          end

          def call(payload) = Pathname.mktmpdir { process payload, it }

          private

          attr_reader :decoder, :struct

          def process payload, directory
            input_path = Pathname(directory).join "input.png"

            input_path.binwrite(decoder.strict_decode64(payload.content))
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
        end
      end
    end
  end
end
