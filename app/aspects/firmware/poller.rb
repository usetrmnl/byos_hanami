# frozen_string_literal: true

module Terminus
  module Aspects
    module Firmware
      # Polls the Core Firmware API on a scheduled interval for new firmware versions.
      class Poller
        def initialize downloader: Terminus::Aspects::Firmware::Downloader.new,
                       kernel: Kernel,
                       seconds: 43_200 # Half day (60 * 60 * 12).
          @downloader = downloader
          @kernel = kernel
          @seconds = seconds
        end

        def call
          watch_for_shudown
          keep_alive
        end

        private

        attr_reader :downloader, :kernel, :seconds

        def watch_for_shudown
          kernel.trap "INT" do
            kernel.puts "Gracefully shutting down firmware polling..."
            kernel.exit
          end
        end

        def keep_alive
          kernel.loop do
            downloader.call
            kernel.sleep seconds
          end
        end
      end
    end
  end
end
