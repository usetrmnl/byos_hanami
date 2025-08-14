# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      module Creators
        # Creates screen record with image attachment from preprocesed image URI.
        class Preprocessed
          include Deps[:mini_magick, repository: "repositories.screen"]
          include Dry::Monads[:result]

          def initialize(struct: Terminus::Structs::Screen.new, **)
            @struct = struct
            super(**)
          end

          def call(payload) = Pathname.mktmpdir { process payload, it }

          def process payload, directory
            path = Pathname(directory).join "input.png"
            mini_magick::Image.open(payload.content).write(path).then { save payload, path }
          end

          private

          attr_reader :struct

          def save payload, path
            path.open { |io| struct.upload io, metadata: {"filename" => payload.filename} }
            repository.create_with_image payload, struct
          end
        end
      end
    end
  end
end
