# frozen_string_literal: true

require "dry/monads"
require "inspectable"

module Terminus
  module Aspects
    module Screens
      module Creators
        # Saves HTML content as image to temporary file path for optional processing.
        class TempPath
          include Deps["aspects.screens.shoter", "aspects.screens.converter"]
          include Terminus::Dependencies[:sanitizer]
          include Dry::Monads[:result]
          include Inspectable[sanitizer: :class]

          def call(mold, &) = Pathname.mktmpdir { process mold, it, & }

          private

          def process mold, directory
            mold.output_path = directory.join mold.filename

            capture_input(mold, directory).bind { converter.call mold }
                                          .bind { |path| block_given? ? yield(path) : path }
          end

          def capture_input mold, directory
            sanitizer.call(mold.content)
                     .then { |content| shoter.call content, directory.join("input.png") }
                     .fmap { |path| mold.input_path = path }
          end
        end
      end
    end
  end
end
