# frozen_string_literal: true

module Terminus
  module Views
    module Setup
      # The new view.
      class New < Terminus::View
        config.layout = "setup"

        expose :device
      end
    end
  end
end
