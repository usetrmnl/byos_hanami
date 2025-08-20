# frozen_string_literal: true

module Terminus
  module Views
    module Screens
      module Gaffe
        # The new view.
        class New < Terminus::View
          config.layout = "gaffe"

          expose :message, decorate: false
        end
      end
    end
  end
end
