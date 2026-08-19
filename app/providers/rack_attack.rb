# auto_register: false
# frozen_string_literal: true

require "refinements/string"

module Terminus
  module Providers
    # The Rack Attack provider.
    class RackAttack < Hanami::Provider::Source
      RESOLVER = proc { Object.const_get "Rack::Attack" }

      using Refinements::String

      def initialize(resolver: RESOLVER, **)
        @resolver = resolver
        super(**)
      end

      def prepare
        require "ipaddr"
        require "rack/attack"
        require "redis"
      end

      def start
        rack_attack.cache.store = Redis.new url: slice[:settings].keyvalue_url

        allow_subnets
        block_blank_agents
        throttle
        register :rack_attack, rack_attack
      end

      private

      attr_reader :resolver

      def allow_subnets
        rack_attack.safelist "allowed_subnets" do |request|
          allowed_subnets.any? { |subnet| subnet.include? request.ip }
        end
      end

      def allowed_subnets
        [
          IPAddr.new("10.0.0.0/8"),
          IPAddr.new("172.16.0.0/12"),
          IPAddr.new("192.168.0.0/16"),
          IPAddr.new("127.0.0.1"),
          IPAddr.new("::1"),
          *slice[:settings].rack_attack_allowed_subnets.split(/,\s*/).map { IPAddr.new it }
        ]
      end

      def block_blank_agents
        rack_attack.blocklist("block_blank_agents") { it.user_agent.to_s.blank? }
      end

      def throttle
        rack_attack.throttled_responder = proc { [503, {}, ["Server Error"]] }

        rack_attack.throttle("ip", limit: 300, period: 300, &:ip)
        throttle_login
        throttle_api_setup
      end

      def throttle_login
        rack_attack.throttle "login", limit: 5, period: 60 do |request|
          login = request.path == "/login" && request.post?
          request.params["login"].to_s.downcase.gsub(/\s+/, "") if login
        end
      end

      def throttle_api_setup
        rack_attack.throttle "api_setup", limit: 10, period: 180 do |request|
          request.ip if request.path == "/api/setup"
        end
      end

      def rack_attack
        @rack_attack ||= resolver.call
      end
    end
  end
end
