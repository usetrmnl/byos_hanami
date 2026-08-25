# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      module Interrupts
        # Renders device identify screen.
        class Identify
          include Deps["aspects.screens.creator", view: "views.screens.interrupts.identify.show"]

          def call device
            creator.call content: String.new(view.call(device:)),
                         **device.screen_attributes("identify")
          end
        end
      end
    end
  end
end
