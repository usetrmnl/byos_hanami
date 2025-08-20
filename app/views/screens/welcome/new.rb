# frozen_string_literal: true

module Terminus
  module Views
    module Screens
      module Welcome
        # The new view.
        class New < Terminus::View
          config.layout = "welcome"

          expose :device
        end
      end
    end
  end
end
