# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Extensions
      # Makes multiple HTTP requests to assemble a collection of data.
      class MultiFetcher
        include Deps["aspects.extensions.capsule", "aspects.extensions.fetcher"]
        include Dry::Monads[:result]

        def call extension
          capsule.clear
          process extension
        end

        private

        def process extension
          extension.uris.one? ? fetch_sole(extension) : fetch_many(extension)

          capsule.errors? ? Failure(capsule) : Success(capsule)
        end

        def fetch_sole extension
          uri = extension.uris.first
          collect "source", uri, fetcher.call(uri, extension)
        end

        def fetch_many extension
          extension.uris.each.with_index 1 do |uri, index|
            collect "source_#{index}", uri, fetcher.call(uri, extension)
          end
        end

        # :reek:FeatureEnvy
        def collect key, uri, result
          if result.success?
            capsule.content[key] = result.success
          else
            capsule.errors[uri] = result.failure
          end
        end
      end
    end
  end
end
