# frozen_string_literal: true

module Terminus
  module Contracts
    module Devices
      # The contract for device creates.
      class Create < Abstract
        params { required(:device).hash Schemas::Device }
      end
    end
  end
end
