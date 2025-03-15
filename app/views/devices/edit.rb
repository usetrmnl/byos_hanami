# frozen_string_literal: true

module Terminus
  module Views
    module Devices
      # The edit view.
      class Edit < Terminus::View
        expose :device
        expose :fields, default: Dry::Core::EMPTY_HASH
        expose :errors, default: Dry::Core::EMPTY_HASH
      end
    end
  end
end
