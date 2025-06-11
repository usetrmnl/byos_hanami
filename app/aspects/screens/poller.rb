# frozen_string_literal: true

require "dry/monads"
require "trmnl/api"

module Terminus
  module Aspects
    module Screens
      # Polls the Core Display API on a scheduled interval for new images to display locally.
      class Poller
        include Deps["aspects.screens.synchronizer", repository: "repositories.device"]
        include Initable[client: proc { TRMNL::API::Client.new }, kernel: Kernel]
        include Dry::Monads[:result]

        # Seconds equates to five minutes (60 * 5).
        def call seconds: 300
          watch_for_shudown
          keep_alive seconds
        end

        private

        def watch_for_shudown
          kernel.trap "INT" do
            kernel.puts "Gracefully shutting down screen polling..."
            kernel.exit
          end
        end

        def keep_alive seconds
          kernel.loop do
            process_devices
            kernel.sleep seconds
          end
        end

        def process_devices = repository.all.select(&:proxy).each { |device| process device }

        def process device
          client.display(token: device.api_key).bind { |record| synchronizer.call record }
        end
      end
    end
  end
end
