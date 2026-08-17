# auto_register: false
# frozen_string_literal: true

module Terminus
  module Middleware
    # Handles Rodauth authentication for the Sidekiq Web interface.
    class SidekiqAuth
      def initialize application
        @application = application
      end

      def call environment
        rodauth = environment["rodauth"]

        halted = catch :halt do
          rodauth.require_account
          nil
        end

        halted || application.call(environment)
      end

      private

      attr_reader :application
    end
  end
end
