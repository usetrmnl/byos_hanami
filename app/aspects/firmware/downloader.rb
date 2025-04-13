# frozen_string_literal: true

require "refinements/pathname"

module Terminus
  module Aspects
    module Firmware
      # A basic file downloader for firmware.
      class Downloader
        include Deps[:settings, fetcher: "aspects.firmware.fetcher"]
        include Dependencies[:http]
        include Dry::Monads[:result]
        include Initable[endpoint: proc { Terminus::Endpoints::Firmware::Requester.new }]

        using Refinements::Pathname

        def call
          result = endpoint.call

          case result
            in Success(payload)
              return Success(path(payload)) if fetcher.call.name.to_s == payload.version

              save payload
            else result
          end
        end

        private

        def save payload
          response = http.get payload.url

          if response.status.success?
            Success path(payload).make_ancestors.write(response.body.to_s)
          else
            Failure response
          end
        end

        def path(payload) = settings.firmware_root.join "#{payload.version}.bin"
      end
    end
  end
end
