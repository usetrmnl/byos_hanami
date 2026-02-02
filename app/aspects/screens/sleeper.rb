# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      # Creates sleep screen for new device.
      class Sleeper
        include Deps["aspects.screens.upserter", view: "views.screens.sleep.new"]

        def call device
          upserter.call model_id: device.model_id,
                        content: String.new(view.call(device:)),
                        **device.screen_attributes("sleep")
        end
      end
    end
  end
end
