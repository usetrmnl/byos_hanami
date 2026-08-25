# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      module Interrupts
        # Renders device sleep screen.
        class Sleep
          include Deps["aspects.screens.creator", view: "views.screens.interrupts.sleep.show"]

          def call device
            creator.call content: String.new(view.call(device:)),
                         **device.screen_attributes("sleep")
          end
        end
      end
    end
  end
end
