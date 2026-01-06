# frozen_string_literal: true

module Terminus
  module Views
    module Models
      # The edit view.
      class Edit < View
        expose :model
        expose :fields, default: Dry::Core::EMPTY_HASH
        expose :errors, default: Dry::Core::EMPTY_HASH
      end
    end
  end
end
