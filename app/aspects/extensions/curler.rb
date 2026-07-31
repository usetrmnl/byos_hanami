# frozen_string_literal: true

require "initable"

module Terminus
  module Aspects
    module Extensions
      # Renders curl command for exchange and associated data.
      class Curler
        include Deps["aspects.extensions.exchanges.request_builder"]
        include Initable[command: "curl", json_formatter: proc { Terminus::Aspects::JSONFormatter }]

        def self.render_headers attributes
          return if Hash(attributes).empty?

          attributes.map { |key, value| "--header '#{key.downcase}: #{value}'" }
        end

        def call extension, exchange
          request_builder.call(exchange, extension)
                         .map { render it }
                         .join "\n"
        end

        private

        def render request
          [
            render_command(request),
            *self.class.render_headers(request.headers),
            render_body(request.body)
          ].compact
           .each
           .with_index
           .map { |line, index| index.zero? ? line : "     #{line}" }
           .join " \\\n"
        end

        def render_command request
          verb = request.verb
          uri = request.uri

          verb.include?("get") ? "#{command} #{uri}" : "#{command} --request #{verb.upcase} #{uri}"
        end

        def render_body attributes
          "--data $'#{json_formatter.call attributes}'" unless Hash(attributes).empty?
        end
      end
    end
  end
end
