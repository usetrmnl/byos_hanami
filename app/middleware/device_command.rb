# auto_register: false
# frozen_string_literal: true

module Terminus
  module Middleware
    class DeviceCommand
      def initialize application
        @application = application
      end

      def call environment
        command = environment["HTTP_COMMAND"]
        status, headers, body = application.call environment
        headers[HTTP_COMMAND] = command if command

        [status, headers, body]
      end

      private

      attr_reader :application
    end
  end
end
