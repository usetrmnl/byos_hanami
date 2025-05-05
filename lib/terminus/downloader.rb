# frozen_string_literal: true

require "dry/monads"
require "refinements/pathname"

module Terminus
  # A simple remote file downloader.
  class Downloader
    include Dependencies[:http, :logger]
    include Dry::Monads[:result]

    using Refinements::Pathname

    def call uri, output_path
      return Success output_path if output_path.exist?

      get(uri).fmap { |content| output_path.make_ancestors.write content }
              .tap { log it }
    end

    private

    def get uri
      http.get(uri).then do |response|
        response.status.success? ? Success(response) : Failure(response)
      end
    rescue OpenSSL::SSL::SSLError => error
      Failure error.message
    end

    def log result
      case result
        in Success(Pathname => path) then logger.info { "Downloaded: #{path}." }
        in Failure(HTTP::Response => response) then log_error response.body
        in Failure(String => message) then log_error message
        else log_error "Unable to perform download."
      end

      result
    end

    def log_error(message) = logger.error { message }
  end
end
