# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Firmware
      # Polls the Core Firmware API on a scheduled interval for new firmware versions.
      class Poller
        include Deps["aspects.firmware.downloader"]
        include Initable[kernel: Kernel]
        include Dry::Monads[:result]

        # Seconds equates to six hours (60 * 60 * 6).
        def call seconds: 21_600
          watch_for_shudown
          keep_alive seconds
        end

        private

        def watch_for_shudown
          kernel.trap "INT" do
            kernel.puts "Gracefully shutting down firmware polling..."
            kernel.exit
          end
        end

        def keep_alive seconds
          kernel.loop do
            downloader.call
            kernel.sleep seconds
          end
        end
      end
    end
  end
end
