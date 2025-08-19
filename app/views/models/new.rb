# frozen_string_literal: true

module Terminus
  module Views
    module Models
      # The new view.
      class New < Terminus::View
        expose :model
        expose :fields, default: Dry::Core::EMPTY_HASH
        expose :errors, default: Dry::Core::EMPTY_HASH
      end
    end
  end
end
