# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Models
      # Polls the Core Models API on a scheduled interval for new (or updated) models.
      class Poller
        include Deps[:settings, "aspects.models.synchronizer"]
        include Initable[kernel: Kernel]
        include Dry::Monads[:result]

        # Seconds equates to 1 day (60 * 60 * 24).
        def call seconds: 86_400
          watch_for_shudown
          keep_alive seconds
        end

        private

        def watch_for_shudown
          kernel.trap "INT" do
            kernel.puts "Gracefully shutting down model polling..."
            kernel.exit
          end
        end

        def keep_alive seconds
          kernel.loop do
            sync_or_skip
            kernel.sleep seconds
          end
        end

        def sync_or_skip
          settings.model_poller ? synchronizer.call : kernel.puts("Model polling disabled.")
        end
      end
    end
  end
end
