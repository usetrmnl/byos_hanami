# frozen_string_literal: true

require "refinements/pathname"

module Terminus
  module Aspects
    module Firmware
      # Finds latest firmware download.
      class Finder
        include Deps[:settings]

        using Refinements::Pathname

        def call = Pathname(settings.firmware_root).then { |root| root.files("*.bin").last || root }
      end
    end
  end
end
