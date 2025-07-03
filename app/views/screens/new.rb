# frozen_string_literal: true

module Terminus
  module Views
    module Screens
      # The new view.
      class New < Terminus::View
        expose :model_options, decorate: false
        expose :screen
        expose :fields, default: Dry::Core::EMPTY_HASH
        expose :errors, default: Dry::Core::EMPTY_HASH
      end
    end
  end
end
