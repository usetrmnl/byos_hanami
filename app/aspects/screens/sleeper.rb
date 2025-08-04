# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      # Creates sleep screen for new device.
      class Sleeper
        include Deps[
          "aspects.screens.creator",
          view: "views.sleep.new",
          repository: "repositories.screen"
        ]
        include Dry::Monads[:result]

        def call device
          repository.find_by(name: device.system_name("sleep"))
                    .then { |screen| screen ? Success(screen) : create(device) }
        end

        private

        def create device
          creator.call content: String.new(view.call(device:)),
                       **device.system_screen_attributes("sleep")
        end
      end
    end
  end
end
