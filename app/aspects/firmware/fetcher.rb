# frozen_string_literal: true

require "refinements/pathname"

module Terminus
  module Aspects
    module Firmware
      # Fetches latest firmware download.
      class Fetcher
        include Deps[:settings]

        using Refinements::Pathname

        def call = settings.firmware_root.then { |root| root.files("*.bin").last || root }
      end
    end
  end
end
