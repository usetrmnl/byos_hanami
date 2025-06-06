# frozen_string_literal: true

require "inspectable"

module Terminus
  module Screens
    module Savers
      # Saves HTML content as a processed image.
      class HTML
        include Terminus::Dependencies[:sanitizer]
        include Inspectable[sanitizer: :class]

        def initialize(screensaver: Screensaver.new, greyscaler: Greyscaler.new, **)
          super(**)
          @screensaver = screensaver
          @greyscaler = greyscaler
        end

        def call content, output_path
          Tempfile.create %w[creator- .jpg] do |file|
            path = file.path

            screensaver.call sanitizer.call(content), path
            greyscaler.call path, output_path
          end
        end

        private

        attr_reader :screensaver, :greyscaler
      end
    end
  end
end
