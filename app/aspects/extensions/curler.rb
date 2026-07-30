# frozen_string_literal: true

require "core"
require "initable"

module Terminus
  module Aspects
    module Extensions
      # Renders curl command for exchange and associated data.
      class Curler
        include Deps["aspects.extensions.exchanges.request_builder"]
        include Initable[json_formatter: proc { Terminus::Aspects::JSONFormatter }]

        def self.render request
          verb = request.verb
          uri = request.uri

          verb.include?("get") ? "curl #{uri}" : "curl --request #{verb.upcase} #{uri}"
        end

        def self.render_headers attributes
          return if Hash(attributes).empty?

          attributes.map { |key, value| "--header '#{key.downcase}: #{value}'" }
        end

        def call extension, exchange
          request_builder.call(exchange, extension)
                         .map { |request| render request }
                         .join "\n"
        end

        private

        def render request
          klass = self.class

          [
            klass.render(request),
            *klass.render_headers(request.headers),
            render_body(request.body)
          ].compact
           .each
           .with_index
           .map { |line, index| index.zero? ? line : "     #{line}" }
           .join " \\\n"
        end

        def render_body attributes
          return if Hash(attributes).empty?

          "--data $'#{json_formatter.call attributes}'"
        end
      end
    end
  end
end
