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

          def call(payload, &) = Pathname.mktmpdir { process payload, it, & }

          private

          def process payload, directory
            sanitizer.call(payload.content)
                     .then { |content| shoter.call(content, directory.join("input.jpg")) }
                     .bind { |path| convert payload, path, directory.join(payload.filename) }
                     .bind { |path| block_given? ? yield(path) : path }
          end

          def convert payload, input_path, output_path
            converter.call payload.model, input_path, output_path
          end
        end
      end
    end
  end
end
