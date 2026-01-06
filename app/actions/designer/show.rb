# frozen_string_literal: true

module Terminus
  module Actions
    module Designer
      # The show action.
      class Show < Action
        def handle(*, response) = response.render view
      end
    end
  end
end
