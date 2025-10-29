# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Extensions
      # Makes multiple HTTP requests to assemble a collection of data.
      class MultiFetcher
        include Deps["aspects.extensions.fetcher"]
        include Dry::Monads[:result]

        def call(extension) = Success collect(extension)

        private

        def collect extension
          extension.uris.each.with_index(1).with_object({}) do |(uri, index), all|
            all["source_#{index}"] = fetcher.call uri, extension
          end
        end
      end
    end
  end
end
