# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Creates a color map for use in PNG image conversion.
      class ColorMapper
        include Deps[:settings, :logger]
        include Dry::Monads[:result]
        include Initable[base: 2, command: "magick", shell: Open3]

        def call bit_depth
          dimensions = "#{base**bit_depth}x1"
          path = settings.color_maps_root.mkpath.join "#{dimensions}.png"

          path.exist? ? Success(path) : create(bit_depth, dimensions, path)
        end

        private

        def create bit_depth, dimensions, path
          colorize(bit_depth).bind { |colors| run colors, dimensions, path }
        end

        def colorize bit_depth
          case bit_depth
            when 1 then Success %w[xc:#000 xc:#FFF]
            when 2 then Success %w[xc:#000 xc:#555 xc:#AAA xc:#FFF]
            when 4 then Success((0..15).map { "xc:##{it.to_s(16).upcase * 3}" })
            else debug { "Color map skipped for bit depth: #{bit_depth}." }
          end
        end

        def run colors, dimensions, path
          return Success(Pathname.new("")) unless colors

          *, error, status = shell.capture3 command,
                                            "-size",
                                            dimensions,
                                            *colors,
                                            "+append",
                                            "-type",
                                            "Palette",
                                            path.to_s

          status.success? ? Success(path) : Failure(error)
        rescue Errno::ENOENT => error
          Failure error.message
        end

        def debug(&)
          logger.debug(&)
          Success nil
        end
      end
    end
  end
end
