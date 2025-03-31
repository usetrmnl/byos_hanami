# frozen_string_literal: true

module Terminus
  module Endpoints
    module CurrentScreen
      # Models API response.
      Response = Data.define :refresh_rate, :image_url, :filename do
        def self.for(attributes) = new(**attributes)
      end
    end
  end
end
