# frozen_string_literal: true

require "dry/monads"
require "mini_magick"

module Terminus
  module Aspects
    module Screens
      module Creators
        # Creates screen record with image attachment from preprocesed image URI.
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
            path.open { |io| struct.upload io, metadata: {"filename" => payload.filename} }
            repository.create_with_image payload, struct
          end
        end
      end
    end
  end
end
