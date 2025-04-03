# frozen_string_literal: true

require "refinements/pathname"

module Terminus
  module Aspects
    module Screens
      # A basic file downloader for screen images.
      class Downloader
        include Deps[:settings]
        include Dependencies[client: :http]
        include Initable[offset: 10] # Seconds.
        include Dry::Monads[:result]

        using Refinements::Pathname

        def call uri, file_name
          at = oldest_at

          get(uri).fmap do |content|
            Pathname(settings.screens_root).join(file_name).write(content).touch at
          end
        end

        def oldest_at
          oldest_file = Pathname(settings.screens_root).files.min_by(&:mtime)

          return Time.now unless oldest_file

          oldest_file.mtime - offset
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
