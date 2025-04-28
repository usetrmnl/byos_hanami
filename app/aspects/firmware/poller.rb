# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Firmware
      # Polls the Core Firmware API on a scheduled interval for new firmware versions.
      class Poller
        include Deps["aspects.firmware.downloader", :logger]
        include Initable[kernel: Kernel, seconds: 21_600] # Six hours (60 * 60 * 6).
        include Dry::Monads[:result]

        def call
          watch_for_shudown
          keep_alive
        end

        private

        def watch_for_shudown
          kernel.trap "INT" do
            kernel.puts "Gracefully shutting down firmware polling..."
            kernel.exit
          end
        end

        def keep_alive
          kernel.loop do
            download
            kernel.sleep seconds
          end
        end

        def download
          case downloader.call
            in Success(path) then logger.info "Downloaded: #{path}."
            in Failure(message) then logger.error message
            else logger.error "Unable to download firmware."
          end
        end
      end
    end
  end
end
