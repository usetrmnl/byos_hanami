# frozen_string_literal: true

module Terminus
  module Endpoints
    module Firmware
      # Models API response.
      Response = Data.define :url, :version do
        def self.for(attributes) = new(**attributes)
      end
    end
  end
end
