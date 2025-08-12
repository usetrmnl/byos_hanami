# frozen_string_literal: true

require "hanami/view"

module Terminus
  module Views
    module Parts
      # The screen presenter.
      class Screen < Hanami::View::Part
        def dimensions = "#{width}x#{height}"
      end
    end
  end
end
