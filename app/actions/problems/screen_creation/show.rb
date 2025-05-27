# frozen_string_literal: true

module Terminus
  module Actions
    module Problems
      module ScreenCreation
        # The show action.
        class Show < Terminus::Action
          def handle(_request, response) = response.render view
        end
      end
    end
  end
end
