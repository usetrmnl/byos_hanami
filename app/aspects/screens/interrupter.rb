# frozen_string_literal: true

require "initable"

module Terminus
  module Aspects
    module Screens
      # Renders immediate screen interrupt for device.
      class Interrupter
        include Deps[
          "aspects.screens.positioner",
          "aspects.screens.interrupts.identify",
          "aspects.screens.interrupts.sleep"
        ]
        include Initable[default_trigger: "button"]

        def call device, trigger: nil
          trigger == default_trigger ? interrupt(device) : sleep_or_forward(device)
        end

        private

        def interrupt device
          case device.command
            when "identify" then identify.call(device)
            when "screen_first" then positioner.call(device, direction: :first)
            when "screen_backward" then positioner.call(device, direction: :backward)
            when "screen_last" then positioner.call(device, direction: :last)
            else sleep_or_forward device
          end
        end

        def sleep_or_forward device
          if device.asleep?
            sleep.call device
          else
            positioner.call device, direction: :forward
          end
        end
      end
    end
  end
end
