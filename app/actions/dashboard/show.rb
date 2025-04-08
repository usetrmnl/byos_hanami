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
          firmware_finder: "aspects.firmware.finder"
        ]

        include Initable[ip_finder: proc { Terminus::IPFinder.new }]

        def handle _request, response
          response.render view,
                          api_uri: settings.api_uri,
                          devices: device_repository.all,
                          firmware_path:,
                          ip_addresses: ip_finder.all
        end

        private

        def firmware_path = firmware_finder.call.relative_path_from config.public_directory
      end
    end
  end
end
