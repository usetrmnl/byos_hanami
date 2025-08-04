# frozen_string_literal: true

require "dry/monads"
require "mini_magick"

module Terminus
  module Aspects
    module Screens
      module Creators
        # Creates screen record with image attachment from unprocessed image URI.
        class Unprocessed
          include Deps["aspects.screens.converter", repository: "repositories.screen"]
          include Dry::Monads[:result]

          def initialize(client: MiniMagick::Image, struct: Terminus::Structs::Screen.new, **)
            @client = client
            @struct = struct
            super(**)
          end

          def call(payload) = Pathname.mktmpdir { process payload, it }

          private

          attr_reader :client, :struct

          def process payload, directory
            input_path = Pathname(directory).join "input.png"

            client.open(payload.content)
                  .write(input_path)
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
