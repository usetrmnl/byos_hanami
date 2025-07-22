# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      # Creates welcome screen for new device.
      class Welcomer
        include Deps[view: "views.setup.new", saver: "aspects.screens.creator"]

        def call device
          id = device.friendly_id

          saver.call model_id: device.model_id,
                     name: "welcome_#{id.downcase}",
                     label: "Welcome #{id}",
                     content: String.new(view.call(device:))
        end
      end
    end
  end
end
