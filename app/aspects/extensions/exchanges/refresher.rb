# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Extensions
      module Exchanges
        # Updates an exchange based on multiple responses.
        class Refresher
          include Deps[
            "aspects.extensions.fetchers.client",
            "aspects.extensions.exchanges.request_builder",
            extension_repository: "repositories.extension",
            exchange_repository: "repositories.extension_exchange"
          ]
          include Initable[request: Fetchers::Request]
          include Dry::Monads[:result]

          def call exchange
            extension_id = exchange.extension_id
            extension = extension_repository.find extension_id

            return Failure "Unable to find extension by ID: #{extension_id}." unless extension

            update exchange, request_builder.call(exchange, extension)
          end

          private

          def update exchange, requests
            id = exchange.id
            payloads = fetch requests, data: exchange.data.dup

            exchange_repository.update id, **payloads, refreshed_at: Time.now
            Success exchange_repository.find id
          end

          def fetch requests, data:, errors: {}
            requests.each.with_index 1 do |request, index|
              key = "source_#{index}"

              case client.call request
                in Success(response) then response.merge_data key, data
                in Failure(response) then response.merge_errors key, errors
                else errors.merge! key => "Unable to fetch, invalid result."
              end
            end

            {data:, errors:}
          end
        end
      end
    end
  end
end
