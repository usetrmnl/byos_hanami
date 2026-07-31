# frozen_string_literal: true

require "initable"

module Terminus
  module Aspects
    module Extensions
      module Exchanges
        # Builds fully rendereed requests.
        class RequestBuilder
          include Deps["aspects.extensions.contextualizer", renderer: "liquid.basic"]
          include Initable[request: Fetchers::Request]

          def call exchange, extension
            context = contextualizer.call extension
            headers = process :headers, exchange, context
            body = process :body, exchange, context

            renderer.call(exchange.template, context).split.map do |uri|
              request[headers:, verb: exchange.verb, uri:, body:]
            end
          end

          private

          def process method, exchange, context
            render Hash(exchange.public_send(method)), context
          end

          def render value, context
            case value
              when Hash then value.transform_values { render it, context }
              when Array then value.map { render it, context }
              when String then renderer.call value, context
              else value
            end
          end
        end
      end
    end
  end
end
