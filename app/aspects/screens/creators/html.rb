# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      module Creators
        # Creates screen record with image attachment from HTML content.
        class HTML
          include Dry::Monads[:result]
          include Deps["aspects.screens.creators.temp_path", repository: "repositories.screen"]
          include Initable[struct: proc { Terminus::Structs::Screen.new }]

          def call(payload) = temp_path.call(payload) { |path| save payload, path }

          private

          def save payload, path
            path.open { |io| struct.upload io, metadata: {"filename" => payload.filename} }
            repository.create_with_image payload, struct
          end
        end
      end
    end
  end
end
