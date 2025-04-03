# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      # Polls the Core Display API on a scheduled interval for new images to display locally.
      class Poller
        include Deps[repository: "repositories.device"]

        # :nocov:
        include Initable[
          endpoint: proc { Terminus::Endpoints::Display::Requester.new },
          downloader: proc { Terminus::Aspects::Screens::Downloader.new },
          kernel: Kernel,
          seconds: 300
        ]

        def call
          kernel.loop do
            process_devices
            kernel.sleep seconds
          end
        end

        private

        def process_devices
          repository.all.select(&:proxy).each { |device| process device }
        end

        def process device
          endpoint.call(api_key: device.api_key)
                  .bind do |response|
                    downloader.call response.image_url, response.filename
                  end
        end
      end
    end
  end
end
