# auto_register: false
# frozen_string_literal: true

module Terminus
  module Providers
    # The Sidekiq provider.
    class Sidekiq < Hanami::Provider::Source
      RESOLVER = proc { Object.const_get "Sidekiq" }

      def initialize(resolver: RESOLVER, **)
        @resolver = resolver
        super(**)
      end

      def prepare
        require "sidekiq"
        require "sidekiq-scheduler"
      end

      def start
        configure_server
        configure_client
        register :sidekiq, sidekiq
      end

      private

      attr_reader :resolver

      def configure_server
        # :nocov:
        sidekiq.configure_server do |configuration|
          configuration.redis = {url: slice[:settings].keyvalue_url}
          configuration.logger = slice[:logger]
        end
        # :nocov:
      end

      def configure_client
        sidekiq.configure_client do |configuration|
          configuration.redis = {url: slice[:settings].keyvalue_url}
          configuration.logger = slice[:logger]
        end
      end

      def sidekiq
        @sidekiq ||= resolver.call
      end
    end
  end
end
