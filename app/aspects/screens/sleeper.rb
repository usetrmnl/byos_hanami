# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      # Creates sleep screen for new device.
      class Sleeper
        include Deps[view: "views.sleep.new", saver: "aspects.screens.creator"]

        def call device
          id = device.friendly_id

          saver.call model_id: device.model_id,
                     name: "sleep_#{id.downcase}",
                     label: "Sleep #{id}",
                     content: String.new(view.call(device:))
        end
      end
    end
  end
end
