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

          def call(mold) = Pathname.mktmpdir { process mold, it }

          def process mold, directory
            path = Pathname(directory).join "input.png"
            mini_magick::Image.open(mold.content).write(path).then { save mold, path }
          end

          private

          attr_reader :struct

          def save mold, path
            path.open { |io| struct.upload io, metadata: {"filename" => mold.filename} }
            repository.create_with_image mold, struct
          end
        end
      end
    end
  end
end
