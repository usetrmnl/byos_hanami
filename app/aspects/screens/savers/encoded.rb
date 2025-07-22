# frozen_string_literal: true

require "base64"
require "dry/monads"

module Terminus
  module Aspects
    module Screens
      module Savers
        # Saves encoded content as a decoded and processed image.
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
            struct = attach payload, path
            Success repository.create(image_data: struct.image_attributes, **payload.attributes)
          rescue ROM::SQL::Error => error
            Failure error.message
          end

          def attach payload, path
            path.open { |io| struct.upload io, metadata: {"filename" => payload.filename} }
            struct
          end
        end
      end
    end
  end
end
