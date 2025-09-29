# frozen_string_literal: true

require "initable"
require "socket"

module Terminus
  # Finds wired and wireless addresses.
  class IPFinder
    include Initable[socket: Socket]

    def all pattern: /\A(en|wl|eth)/
      socket.getifaddrs.select do |interface|
        address = interface.addr
        interface.name.match?(pattern) && address.ipv4? && !address.ipv4_loopback?
      end
    end

    def wired pattern: /\A(en[1-9]|eth)/
      all.find { |address| address.name.match? pattern }
         .then { it.addr.ip_address if it }
    end
  end
end
