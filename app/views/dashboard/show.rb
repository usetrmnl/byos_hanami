# frozen_string_literal: true

module Terminus
  module Views
    module Dashboard
      # The show view.
      class Show < Terminus::View
        expose :api_uri
        expose :devices
        expose :ip_addresses
        expose :firmwares
      end
    end
  end
end
