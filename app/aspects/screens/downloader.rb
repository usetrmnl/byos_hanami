# frozen_string_literal: true

require "dry/core"
require "dry/monads"
require "mini_magick"
require "refinements/pathname"

module Terminus
  module Aspects
    module Screens
      # A basic file downloader for screen images.
      class Downloader
        include Deps[:settings]
        include Dependencies[client: :http]
        include Initable[seconds: 10, imager: MiniMagick::Image]
        include Dry::Monads[:result]

        using Refinements::Pathname

        def call uri, path
          asset_path = settings.screens_root.join(path).make_ancestors

          get(uri).fmap { |content| asset_path.write(content) }
                  .bind { |full_path| rename full_path }
                  .fmap { |full_path| full_path.touch oldest_at(asset_path) }
        end

        private

        def rename path
          type = imager.open(path)
                       .data
                       .fetch("mimeType", Dry::Core::EMPTY_STRING)
                       .sub "image/", Dry::Core::EMPTY_STRING

          updated_path = path.sub_ext ".#{type}"
          path.rename updated_path
          Success updated_path
        rescue Errno::ENOENT, OpenSSL::SSL::SSLError, MiniMagick::Error
          Failure "Unable to analyze image: #{path}."
        end

        def oldest_at(path) = path.parent.files.min_by(&:mtime).mtime - seconds

        def get uri
          client.get(uri).then do |response|
            response.status.success? ? Success(response) : Failure(response)
          end
        end
      end
    end
  end
end
