# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      # Polls the Core Display API on a scheduled interval for new images to display locally.
      class Poller
        include Deps["aspects.screens.downloader", repository: "repositories.device"]

        include Initable[
          endpoint: proc { Terminus::Endpoints::Display::Requester.new },
          kernel: Kernel,
          seconds: 300
        ]

        def call
          watch_for_shudown
          keep_alive
        end

        private

        def watch_for_shudown
          kernel.trap "INT" do
            kernel.puts "Gracefully shutting down screen polling..."
            kernel.exit
          end
        end

        def keep_alive
          kernel.loop do
            process_devices
            kernel.sleep seconds
          end
        end

        def process_devices
          repository.all.select(&:proxy).each { |device| process device }
        end

        def process device
          endpoint.call(api_key: device.api_key)
                  .bind do |response|
                    downloader.call response.image_url, "#{device.slug}/#{response.filename}"
                  end
        end
      end
    end
  end
end
