# frozen_string_literal: true

require "dry/monads"
require "initable"
require "mini_magick"

module Terminus
  module Screens
    module Savers
      # Saves URI as a preprocessed image.
      class PreprocessedURI
        include Dry::Monads[:result]
        include Initable[client: MiniMagick::Image]

        def call uri, output_path
          client.open(uri).write output_path
          Success output_path
        rescue StandardError => error
          Failure error.message
        end
      end
    end
  end
end
