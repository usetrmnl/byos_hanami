# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Creates welcome screen for new device.
      class Welcomer
        include Deps[:settings, view: "views.setup.new"]
        include Terminus::Screens::Savers::Dependencies[creator: :html]
        include Initable[seconds: 30]
        include Dry::Monads[:result]

        def call device, now: Time.now
          output_path = path_for device

          return Success output_path if output_path.exist? || (now - device.created_at) >= seconds

          creator.call "#{view.call device:} ", output_path
        end

        private

        def path_for(device) = settings.screens_root.join(device.slug).mkpath.join "setup.png"
      end
    end
  end
end
