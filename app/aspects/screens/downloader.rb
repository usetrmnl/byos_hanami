# frozen_string_literal: true

require "cgi"
require "dry/core"
require "dry/monads"
require "initable"
require "mini_magick"
require "refinements/pathname"

module Terminus
  module Aspects
    module Screens
      # A basic file downloader for screen images.
      class Downloader
        include Deps[:settings, "aspects.screens.deduplicator"]
        include Dependencies[client: :downloader]
        include Initable[cgi: CGI]
        include Dry::Monads[:result]

        using Refinements::Pathname

        FILE_PATTERN = /
          (                   # Conditional start.
          plugin-             # Plugin prefix.
          \d{4}-\d{2}-\d{2}   # Date.
          T                   # Date and time delimiter.
          \d{2}-\d{2}-\d{2}Z  # Time with zone.
          -                   # Dash suffix.
          |                   # Or.
          -                   # Dash prefix.
          \d{10}              # Cache buster timestamp.
          )                   # Conditional end.
        /x

        def initialize(file_pattern: FILE_PATTERN, **)
          @file_pattern = file_pattern
          super(**)
        end

        def call uri, path
          type = type_for uri

          return Failure "Invalid image type: #{type.inspect}." if type.empty?

          client.call(uri, settings.screens_root.join(path))
                .bind { |download_path| deduplicator.call download_path, sanitize(path, type) }
        end

        private

        attr_reader :file_pattern

        def type_for uri
          cgi.parse(uri)
             .fetch("response-content-type", Dry::Core::EMPTY_ARRAY)
             .first
             .to_s
             .sub("image/", Dry::Core::EMPTY_STRING)
        end

        def sanitize path, type
          stripped = path.gsub(file_pattern, Dry::Core::EMPTY_STRING).sub("/", "/proxy-")
          settings.screens_root.join "#{stripped}.#{type}"
        end
      end
    end
  end
end
