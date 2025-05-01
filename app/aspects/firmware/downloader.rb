# frozen_string_literal: true

require "refinements/pathname"
require "trmnl/api"

module Terminus
  module Aspects
    module Firmware
      # A basic file downloader for firmware.
      class Downloader
        include Deps[:settings, fetcher: "aspects.firmware.fetcher"]
        include Dependencies[:http]
        include Dry::Monads[:result]
        include Initable[endpoint: proc { TRMNL::API::Endpoints::Firmware.new }]

        using Refinements::Pathname

        def call
          result = endpoint.call

          case result
            in Success(payload)
              return Success(path(payload)) if latest_firmware_version == payload.version

              save payload
            else result
          end
        end

        private

        def path(payload) = settings.firmware_root.join "#{payload.version}.bin"

        def latest_firmware_version = fetcher.call.first.then { it.version if it }

        def save payload
          get(payload.url).fmap { |content| path(payload).make_ancestors.write(content) }
        end

        def get uri
          http.get(uri).then do |response|
            content = response.body.to_s

            response.status.success? ? Success(content) : Failure(content)
          end
        rescue OpenSSL::SSL::SSLError => error
          Failure error.message
        end
      end
    end
  end
end
