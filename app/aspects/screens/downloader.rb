# frozen_string_literal: true

require "refinements/pathname"

module Terminus
  module Aspects
    module Screens
      # A basic file downloader for screen images.
      class Downloader
        include Deps[:settings]
        include Dependencies[client: :http]
        include Initable[seconds: 10]
        include Dry::Monads[:result]

        using Refinements::Pathname

        def call uri, path
          asset_path = settings.screens_root.join(path).make_ancestors
          at = oldest_at asset_path

          get(uri).fmap { |content| asset_path.write(content).touch at }
        end

        def oldest_at path
          oldest_file = path.parent.files.min_by(&:mtime)

          return Time.now unless oldest_file

          oldest_file.mtime - seconds
        end

        def get uri
          client.get(uri)
                .then do |response|
                  response.status.success? ? Success(response) : Failure(response)
                end
        end
      end
    end
  end
end
