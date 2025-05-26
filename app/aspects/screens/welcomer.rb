# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Screens
      # Creates welcome screen for new device.
      class Welcomer
        include Deps[:settings, view: "views.setup.new"]
        include Dry::Monads[:result]

        def initialize(creator: Terminus::Screens::HTMLSaver.new, seconds: 30, **)
          @creator = creator
          @seconds = seconds
          super(**)
        end

        def call device, now: Time.now
          output_path = path_for device

          return Success output_path if output_path.exist? || (now - device.created_at) >= seconds

          creator.call "#{view.call device:} ", output_path
        end

        private

        attr_reader :creator, :seconds

        def path_for(device) = settings.screens_root.join(device.slug).mkpath.join "setup.png"
      end
    end
  end
end
