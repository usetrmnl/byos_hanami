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
            headers = render_values :headers, exchange, context
            body = render_values :body, exchange, context

            renderer.call(exchange.template, context).split.map do |uri|
              request[headers:, verb: exchange.verb, uri:, body:]
            end
          end

          private

          def render_values method, exchange, context
            Hash(exchange.public_send(method)).each.with_object({}) do |(key, value), all|
              all[key] = renderer.call value, context
            end
          end
        end
      end
    end
  end
end
