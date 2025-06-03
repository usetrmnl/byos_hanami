# frozen_string_literal: true

module Terminus
  module Contracts
    module Devices
      # The contract for device updates.
      class Update < Abstract
        params do
          required(:id).filled :integer
          required(:device).hash Schemas::Device
        end
      end
    end
  end
end
