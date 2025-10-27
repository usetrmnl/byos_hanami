# frozen_string_literal: true

module Terminus
  module Providers
    # The logger provider.
    class Logger < Hanami::Provider::Source
      RESOLVER = proc { Object.const_get "Cogger" }

      def initialize(environment: Hanami.env, resolver: RESOLVER, **)
        @environment = environment
        @resolver = resolver
        @id = Hanami.app.namespace.to_s.downcase.to_sym
        super(**)
      end

      def prepare = require "cogger"

      def start
        add_filters
        register :logger, build_instance
      end

      private

      attr_reader :environment, :resolver, :id

      def add_filters
        core.add_filters :api_key,
                         :csrf,
                         :HTTP_ACCESS_TOKEN,
                         :HTTP_ID,
                         :mac_address,
                         :password,
                         :password_confirmation
      end

      def build_instance
        io = "log/#{environment}.log"

        case environment
          when :test
            core.new(id:, io: StringIO.new, formatter: :json, level: :debug).add_stream io:
          when :development then core.new(id:).add_stream(io:, formatter: :json)
          else core.new id:, formatter: :json
        end
      end

      def core
        @core ||= resolver.call
      end
    end
  end
end
