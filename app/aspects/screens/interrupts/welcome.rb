# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      module Interrupts
        # Renders device sleep screen.
        class Welcome
          include Deps["aspects.screens.creator", view: "views.screens.interrupts.welcome.show"]

          def call device
            creator.call content: String.new(view.call(device:)),
                         **device.screen_attributes("welcome")
          end
        end
      end
    end
  end
end
