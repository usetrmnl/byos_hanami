# frozen_string_literal: true

require "initable"

module Terminus
  module Actions
    module Dashboard
      # The show action.
      class Show < Terminus::Action
        include Deps[:settings, device_repository: "repositories.device"]
        include Initable[ip_finder: proc { Terminus::IPFinder.new }]

        def handle _request, response
          response.render view,
                          devices: device_repository.all,
                          ip_addresses: ip_finder.all,
                          api_uri: settings.api_uri
        end
      end
    end
  end
end
