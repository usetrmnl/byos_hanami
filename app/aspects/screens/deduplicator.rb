# frozen_string_literal: true

require "dry/monads"
require "mini_magick"
require "refinements/pathname"

module Terminus
  module Aspects
    module Screens
      # Prevents screen duplication.
      class Deduplicator
        include Initable[imager: MiniMagick::Image, seconds: 10]
        include Dry::Monads[:result]

        using Refinements::Pathname

        def call download_path, current_path
          if current_path.exist?
            maybe_update download_path, current_path
          else
            download_path.rename current_path
            current_path.touch oldest_at(current_path)
          end

          Success current_path
        rescue Errno::ENOENT, MiniMagick::Error
          Failure "Unable to analyze images for deduplication."
        end

        private

        def maybe_update download_path, current_path
          unless imager.open(download_path).signature == imager.open(current_path).signature
            download_path.copy current_path
            current_path.touch oldest_at(current_path)
          end

          download_path.delete
        end

        def oldest_at(path) = path.parent.files.min_by(&:mtime).mtime - seconds
      end
    end
  end
end
