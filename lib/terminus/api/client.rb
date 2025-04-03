# frozen_string_literal: true

require "dry/monads"
require "http"

module Terminus
  module API
    # Provides a low level configurable and monadic API client.
    class Client
      include Initable[settings: proc { Terminus::API::Configuration.new }]
      include Terminus::Dependencies[:http]
      include Dry::Monads[:result]

      def get path, api_key: nil, **parameters
        call __method__, path, api_key: api_key, params: parameters
      end

      private

      def call method, path, **options
        headers = settings.headers.merge "Access-Token" => options.delete(:api_key)

        http.headers(headers)
            .public_send(method, "#{settings.api_uri}/#{path}", options)
            .then { |response| response.status.success? ? Success(response) : Failure(response) }
      end
    end
  end
end
