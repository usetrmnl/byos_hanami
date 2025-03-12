# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      # The new action.
      class New < Terminus::Action
        def handle *, response
          response.render view, errors: Dry::Core::EMPTY_HASH, layout: false
        end
      end
    end
  end
end
