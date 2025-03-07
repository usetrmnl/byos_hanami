# frozen_string_literal: true

module Terminus
  module Images
    # Creates device image.
    class Creator
      def initialize screensaver: Screensaver.new, greyscaler: Greyscaler.new
        @screensaver = screensaver
        @greyscaler = greyscaler
      end

      def call content, output_path
        Tempfile.create %w[creator- .jpg] do |file|
          path = file.path

          screensaver.call content, path
          greyscaler.call path, output_path
        end
      end

      private

      attr_reader :screensaver, :greyscaler
    end
  end
end
