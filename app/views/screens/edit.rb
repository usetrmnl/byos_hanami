# frozen_string_literal: true

module Terminus
  module Views
    module Screens
      # The edit view.
      class Edit < Terminus::View
        expose :models
        expose :screen
        expose :fields, default: Dry::Core::EMPTY_HASH
        expose :errors, default: Dry::Core::EMPTY_HASH
      end
    end
  end
end
