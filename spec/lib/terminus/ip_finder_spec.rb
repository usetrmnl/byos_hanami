# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::IPFinder do
  subject(:finder) { described_class.new socket: }

  let(:socket) { class_double Socket }

  before { allow(socket).to receive(:getifaddrs).and_return(addresses) }

  describe "#all" do
    let(:result) { finder.all.map { it.addr.ip_address } }

    context %(with "en" network name) do
      let :addresses do
        [
          instance_double(
            Socket::Ifaddr,
            name: "en0",
            addr: instance_double(
              Addrinfo,
              ip_address: "192.168.1.111",
              ipv4?: true,
              ipv4_loopback?: false
            )
          )
        ]
      end

      it "answers matching addresses" do
        expect(result).to contain_exactly("192.168.1.111")
      end
    end

    context %(with "wl" network name) do
      let :addresses do
        [
          instance_double(
            Socket::Ifaddr,
            name: "wlan0",
            addr: instance_double(
              Addrinfo,
              ip_address: "192.168.1.111",
              ipv4?: true,
              ipv4_loopback?: false
            )
          )
        ]
      end

      it "answers matching addresses" do
        expect(result).to contain_exactly("192.168.1.111")
      end
    end

    context "with unknown network name" do
      let :addresses do
        [
          instance_double(
            Socket::Ifaddr,
            name: "bogus",
            addr: instance_double(
              Addrinfo,
              ip_address: "192.168.1.111",
              ipv4?: true,
              ipv4_loopback?: false
            )
          )
        ]
      end

      it "answers empty array" do
        expect(result).to eq([])
      end
    end

    context "with custom pattern" do
      let :addresses do
        [
          instance_double(
            Socket::Ifaddr,
            name: "ps20",
            addr: instance_double(
              Addrinfo,
              ip_address: "192.168.1.111",
              ipv4?: true,
              ipv4_loopback?: false
            )
          )
        ]
      end

      it "answers matching address" do
        result = finder.all(pattern: /\Aps/).map { it.addr.ip_address }
        expect(result).to contain_exactly("192.168.1.111")
      end
    end

    context "when not IPV4" do
      let :addresses do
        [
          instance_double(
            Socket::Ifaddr,
            name: "en0",
            addr: instance_double(
              Addrinfo,
              ip_address: "192.168.1.111",
              ipv4?: false,
              ipv4_loopback?: false
            )
          )
        ]
      end

      it "answers empty array" do
        expect(result).to eq([])
      end
    end

    context "when IPV4 loopback" do
      let :addresses do
        [
          instance_double(
            Socket::Ifaddr,
            name: "en0",
            addr: instance_double(
              Addrinfo,
              ip_address: "192.168.1.111",
              ipv4?: true,
              ipv4_loopback?: true
            )
          )
        ]
      end

      it "answers empty array" do
        expect(result).to eq([])
      end
    end

    context "when custom pattern" do
      let :addresses do
        [
          instance_double(
            Socket::Ifaddr,
            name: "ps20",
            addr: instance_double(
              Addrinfo,
              ip_address: "192.168.1.111",
              ipv4?: true,
              ipv4_loopback?: true
            )
          )
        ]
      end

      it "answers empty array" do
        expect(result).to eq([])
      end
    end
  end

  describe "#wired" do
    context %(with "en" name higher than zero) do
      let :addresses do
        [
          instance_double(
            Socket::Ifaddr,
            name: "en1",
            addr: instance_double(
              Addrinfo,
              ip_address: "192.168.1.111",
              ipv4?: true,
              ipv4_loopback?: false
            )
          )
        ]
      end

      it "answers matching address" do
        expect(finder.wired).to eq("192.168.1.111")
      end
    end

    context %(with any "eth" name) do
      let :addresses do
        [
          instance_double(
            Socket::Ifaddr,
            name: "eth0",
            addr: instance_double(
              Addrinfo,
              ip_address: "192.168.1.111",
              ipv4?: true,
              ipv4_loopback?: false
            )
          )
        ]
      end

      it "answers matching address" do
        expect(finder.wired).to eq("192.168.1.111")
      end
    end

    context %(with "en0" name) do
      let :addresses do
        [
          instance_double(
            Socket::Ifaddr,
            name: "en0",
            addr: instance_double(
              Addrinfo,
              ip_address: "192.168.1.111",
              ipv4?: true,
              ipv4_loopback?: false
            )
          )
        ]
      end

      it "answers nil" do
        expect(finder.wired).to be(nil)
      end
    end

    context "with excluded name" do
      let :addresses do
        [
          instance_double(
            Socket::Ifaddr,
            name: "wlan0",
            addr: instance_double(
              Addrinfo,
              ip_address: "192.168.1.111",
              ipv4?: true,
              ipv4_loopback?: false
            )
          )
        ]
      end

      it "answers nil" do
        expect(finder.wired).to be(nil)
      end
    end

    context "with custom pattern" do
      let :addresses do
        [
          instance_double(
            Socket::Ifaddr,
            name: "wlan1",
            addr: instance_double(
              Addrinfo,
              ip_address: "192.168.1.111",
              ipv4?: true,
              ipv4_loopback?: false
            )
          )
        ]
      end

      it "answers matching address" do
        expect(finder.wired(pattern: /\Awl/)).to eq("192.168.1.111")
      end
    end
  end
end
