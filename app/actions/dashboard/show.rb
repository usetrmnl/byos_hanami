# frozen_string_literal: true

require "initable"

module Terminus
  module Actions
    module Dashboard
      # The show action.
      class Show < Terminus::Action
        include Deps[
          :settings,
          device_repository: "repositories.device",
          firmware_fetcher: "aspects.firmware.fetcher"
        ]

        include Initable[ip_finder: proc { Terminus::IPFinder.new }]

        def handle _request, response
          response.render view,
                          api_uri: settings.api_uri,
                          devices: device_repository.all,
                          firmwares: firmware_fetcher.call,
                          ip_addresses: ip_finder.all
        end
      end
    end
  end
end
