# frozen_string_literal: true

module Terminus
  module Views
    module Dashboard
      # The show view.
      class Show < Terminus::View
        expose :devices
        expose :ip_addresses
        expose :api_uri
      end
    end
  end
end
