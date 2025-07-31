# frozen_string_literal: true

module Terminus
  module Views
    module Gaffe
      # The new view.
      class New < Terminus::View
        config.layout = "gaffe"

        expose :problem
      end
    end
  end
end
