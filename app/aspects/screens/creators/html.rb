# frozen_string_literal: true

require "dry/monads"
require "initable"
require "inspectable"

module Terminus
  module Aspects
    module Screens
      module Creators
        # Creates screen record with image attachment from HTML content.
        class HTML
          include Dry::Monads[:result]
          include Inspectable[sanitizer: :class]
          include Deps[
            "aspects.screens.shoter",
            "aspects.screens.converter",
            repository: "repositories.screen"
          ]
          include Terminus::Dependencies[:sanitizer]
          include Initable[struct: proc { Terminus::Structs::Screen.new }]

          def call(payload) = Pathname.mktmpdir { process payload, it }

          private

          def process payload, directory
            sanitizer.call(payload.content)
                     .then { |content| shoter.call(content, directory.join("input.jpg")) }
                     .bind { |path| convert payload, path, directory.join(payload.filename) }
                     .bind { |path| save payload, path }
          end

          def convert payload, input_path, output_path
            converter.call payload.model, input_path, output_path
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
