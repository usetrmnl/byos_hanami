# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Creates a 2-bit color map for use with 2-bit PNGs.
      class ColorMapper
        include Deps[:settings]
        include Dry::Monads[:result]

        include Initable[
          [:opt, :name, "2_bit.png"],
          shell: Open3,
          command: %w[
            magick -size 4x1 xc:#000000 xc:#555555 xc:#aaaaaa xc:#ffffff +append -type Palette
          ]
        ]

        def call
          settings.color_maps_root.mkpath.join(name).then do |path|
            path.exist? ? Success(path) : create(path)
          end
        end

        private

        def create path
          shell.capture3(*command, path.to_s).then do |_output, error, status|
            status.success? ? Success(path) : Failure(error)
          end
        end
      end
    end
  end
end
