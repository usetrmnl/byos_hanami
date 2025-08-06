# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    # A generic poller for synchronizing data with the Core server.
    class Poller
      include Deps[:settings]
      include Dependencies[:logger]
      include Initable[%i[req name], %i[req synchronizer], kernel: Kernel]
      include Dry::Monads[:result]

      def call seconds:
        watch_for_shudown
        keep_alive seconds
      end

      private

      def watch_for_shudown
        kernel.trap "INT" do
          logger.info { "Gracefully shutting down #{name} polling..." }
          kernel.exit
        end
      end

      def keep_alive seconds
        kernel.loop do
          log sync_or_skip
          kernel.sleep seconds
        end
      end

      def sync_or_skip
        if settings.public_send "#{name}_poller"
          synchronizer.call
        else
          Success "#{name.capitalize} polling disabled."
        end
      end

      def log result
        case result
          in Success(message) then logger.info { message }
          in Failure(message) then logger.error { message }
          else logger.fatal { "Unable to synchronize." }
        end
      end
    end
  end
end
