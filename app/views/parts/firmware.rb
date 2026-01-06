# frozen_string_literal: true

require "hanami/view"

module Terminus
  module Views
    module Parts
      # The firmware presenter.
      class Firmware < Hanami::View::Part
        def kind_label
          case kind
            when "trmnl" then kind.upcase
            else kind.capitalize
          end
        end
      end
    end
  end
end
