# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      # Creates sleep screen for new device.
      class Sleeper
        include Deps[:settings, view: "views.sleep.new"]
        include Terminus::Screens::Savers::Dependencies[creator: :html]
        include Dry::Monads[:result]

        def call device
          output_path = path_for device

          return Success output_path if output_path.exist?

          creator.call "#{view.call device:} ", output_path
        end

        private

        def path_for(device) = settings.screens_root.join(device.slug).mkpath.join "sleep.png"
      end
    end
  end
end
