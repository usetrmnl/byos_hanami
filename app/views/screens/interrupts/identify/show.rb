# frozen_string_literal: true

module Terminus
  module Views
    module Screens
      module Interrupts
        module Identify
          # The show view.
          class Show < Interrupts::Show
            expose :device
          end
        end
      end
    end
  end
end
