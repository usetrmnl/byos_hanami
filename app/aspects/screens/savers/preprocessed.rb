# frozen_string_literal: true

require "dry/monads"
require "mini_magick"

module Terminus
  module Aspects
    module Screens
      module Savers
        # Saves URI as a preprocessed image.
        class Preprocessed
          include Deps[repository: "repositories.screen"]
          include Dry::Monads[:result]

          def initialize(client: MiniMagick::Image, struct: Terminus::Structs::Screen.new, **)
            @client = client
            @struct = struct
            super(**)
          end

          def call(payload) = Pathname.mktmpdir { process payload, it }

          def process payload, directory
            path = Pathname(directory).join "input.png"
            client.open(payload.content).write(path).then { save payload, path }
          end

          private

          attr_reader :client, :struct

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
