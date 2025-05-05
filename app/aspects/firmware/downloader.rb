# frozen_string_literal: true

require "refinements/pathname"
require "trmnl/api"

module Terminus
  module Aspects
    module Firmware
      # A basic file downloader for firmware.
      class Downloader
        include Deps[:settings, fetcher: "aspects.firmware.fetcher"]
        include Dependencies[client: :downloader]
        include Dry::Monads[:result]
        include Initable[endpoint: proc { TRMNL::API::Endpoints::Firmware.new }]

        using Refinements::Pathname

        def call
          result = endpoint.call

          case result
            in Success(payload)
              version = payload.version
              path = settings.firmware_root.join "#{version}.bin"

              return Success path if latest_firmware_version == version

              save payload, path
            else result
          end
        end

        private

        def latest_firmware_version
          fetcher.call.first.then { it.version if it }
        end

        def save(payload, path) = client.call payload.url, path
      end
    end
  end
end
