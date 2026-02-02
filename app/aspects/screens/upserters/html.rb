# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      module Upserters
        # Creates screen record with image attachment from HTML content.
        class HTML
          include Deps["aspects.screens.upserters.temp_path", repository: "repositories.screen"]
          include Initable[struct: proc { Terminus::Structs::Screen.new }]
          include Dry::Monads[:result]

          def call mold
            temp_path.call(mold) { |path| Success repository.upsert_with_image(path, mold, struct) }
          end
        end
      end
    end
  end
end
