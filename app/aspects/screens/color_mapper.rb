# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Creates a color map for use in PNG image conversion.
      class ColorMapper
        include Deps[:settings]
        include Dry::Monads[:result]
        include Initable[base: 2, command: "magick", shell: Open3]

        def call bit_depth
          dimensions = "#{base**bit_depth}x1"
          path = settings.color_maps_root.mkpath.join "#{dimensions}.png"

          path.exist? ? Success(path) : create(bit_depth, dimensions, path)
        end

        private

        def create bit_depth, dimensions, path
          colorize(bit_depth).fmap { |colors| build_command_line dimensions, colors }
                             .bind { |command_line| run command_line, path }
        end

        def colorize bit_depth
          case bit_depth
            when 1 then Success %w[xc:#000 xc:#FFF]
            when 2 then Success %w[xc:#000 xc:#555 xc:#AAA xc:#FFF]
            when 4 then Success((0..15).map { "xc:##{it.to_s(16).upcase * 3}" })
            else Failure "Unable to create grayscale color map for bit depth: #{bit_depth}."
          end
        end

        def build_command_line dimensions, colors
          [command, "-size", dimensions, *colors, "+append", "-type", "Palette"]
        end

        def run command_line, path
          shell.capture3(*command_line, path.to_s).then do |_output, error, status|
            status.success? ? Success(path) : Failure(error)
          end
        rescue Errno::ENOENT => error
          Failure error.message
        end
      end
    end
  end
end
