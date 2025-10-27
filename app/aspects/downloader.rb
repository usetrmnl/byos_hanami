# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    # A simple content downloader.
    class Downloader
      include Deps[:http, :logger]
      include Dry::Monads[:result]

      def call(uri) = get(uri).tap { log it, uri }

      private

      def get uri
        http.get(uri).then do |response|
          response.status.success? ? Success(response) : Failure(response)
        end
      rescue OpenSSL::SSL::SSLError => error
        Failure error.message
      end

      def log result, uri
        case result
          in Success then logger.info { "Downloaded: #{uri}." }
          in Failure(HTTP::Response => response) then log_error response.body
          in Failure(String => message) then log_error message
          else log_error "Unable to download: #{uri.inspect}."
        end

        result
      end

      def log_error(message) = logger.error { message }
    end
  end
end
