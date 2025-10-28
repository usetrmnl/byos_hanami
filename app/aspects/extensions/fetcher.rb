# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Extensions
      # Fetches remote data.
      class Fetcher
        include Deps[:http]
        include Initable[parser: Terminus::Aspects::Extensions::Parser]
        include Dry::Monads[:result]

        def call(uri, extension) = request(uri, extension).bind { parse it.mime_type, it.body }

        private

        def request uri, extension
          http.headers(extension.headers)
              .public_send(extension.verb, uri)
              .then { it.status.success? ? Success(it) : Failure(it) }
        end

        def parse type, body
          case type
            when "application/json" then parser.from_json body
            when %r(image/.+) then Success(body)
            when "text/csv" then parser.from_csv body
            when "text/plain" then parser.from_text body
            when "text/xml", "application/xml", "application/rss+xml", "application/atom+xml"
              parser.from_xml body
            else Failure "Unknown MIME Type: #{type}."
          end
        end
      end
    end
  end
end
