# frozen_string_literal: true

module Terminus
  module Views
    module Screens
      module Interrupts
        module Error
          # The show view.
          class Show < Interrupts::Show
            expose :message
          end
        end
      end
    end
  end
end
