# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Parts::IPAddress do
  using Refinements::Pathname

  subject(:part) { described_class.new value: address, rendering: view.new.rendering }

  let :address do
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
  end

  let :view do
    Class.new Hanami::View do
      config.paths = [Hanami.app.root.join("app/templates")]
      config.template = "n/a"
    end
  end

  describe "#address" do
    it "answers address" do
      expect(part.address).to eq("192.168.1.111")
    end
  end

  describe "#address_with_kind" do
    it "answers address with kind in parenthesis" do
      expect(part.address_with_kind).to eq("192.168.1.111 (wireless)")
    end
  end

  describe "#kind" do
    it "answers wired when name ends in zero" do
      expect(part.kind).to eq(:wireless)
    end

    it "answers wireless when name ends in non-zero" do
      allow(address).to receive(:name).and_return "en1"
      expect(part.kind).to eq(:wired)
    end
  end
end
