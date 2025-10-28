# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Extensions
      # Fetches remote data.
      class Fetcher
        include Deps[:http]
        include Dry::Monads[:result]

        PARSERS = {
          csv: Terminus::Aspects::Extensions::Parsers::CSV,
          json: Terminus::Aspects::Extensions::Parsers::JSON,
          text: Terminus::Aspects::Extensions::Parsers::Text,
          xml: Terminus::Aspects::Extensions::Parsers::XML
        }.freeze

        def initialize(parsers: PARSERS, **)
          @parsers = parsers
          super(**)
        end

        def call(uri, extension) = request(uri, extension).bind { parse it.mime_type, it.body }

        private

        attr_reader :parsers

        # :reek:FeatureEnvy
        def request uri, extension
          http.headers(extension.headers)
              .public_send(extension.verb, uri)
              .then { it.status.success? ? Success(it) : Failure(it) }
        end

        def parse type, body
          case type
            when "application/json" then parsers.fetch(:json).call body
            when "text/csv" then parsers.fetch(:csv).call body
            when "text/plain" then parsers.fetch(:text).call body
            when "text/xml", "application/xml", "application/rss+xml", "application/atom+xml"
              parsers.fetch(:xml).call body
            else Failure "Unknown MIME Type: #{type}."
          end
        end
      end
    end
  end
end
