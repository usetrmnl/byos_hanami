# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Providers::RackAttack do
  subject(:provider) { described_class.new provider_container:, target_container:, slice: }

  let(:provider_container) { Dry::Core::Container.new }
  let(:target_container) { Dry::Core::Container.new }
  let(:slice) { Hanami.app }

  include_context "with application dependencies"

  describe "#start" do
    let(:rack_attack) { provider_container[:rack_attack] }
    let(:request) { Rack::Attack::Request.new({}) }

    before do
      provider.prepare
      provider.start
    end

    it "answers cache client" do
      expect(rack_attack.cache.store).to be_a(Rack::Attack::StoreProxy::RedisProxy)
    end

    it "answers safe lists" do
      expect(rack_attack.safelists).to match("allowed_subnets" => kind_of(Rack::Attack::Safelist))
    end

    it "answers true for allowed subnet" do
      allow(request).to receive(:ip).and_return "::1"
      result = rack_attack.safelists["allowed_subnets"].block.call request

      expect(result).to be(true)
    end

    it "answers true for custom subnet" do
      allow(settings).to receive(:rack_attack_allowed_subnets).and_return("255.255.255.255")
      allow(request).to receive(:ip).and_return "255.255.255.255"
      result = rack_attack.safelists["allowed_subnets"].block.call request

      expect(result).to be(true)
    end

    it "answers false for unknown subnet" do
      allow(request).to receive(:ip).and_return "255.255.255.255"
      result = rack_attack.safelists["allowed_subnets"].block.call request

      expect(result).to be(false)
    end

    it "blocks user agent when blank" do
      allow(request).to receive_messages(user_agent: " \r\n\t", path: "/")
      result = rack_attack.blocklists["block_blank_agents"].block.call request

      expect(result).to be(true)
    end

    it "doesn't block when user agent exists" do
      allow(request).to receive_messages(user_agent: "Test", path: "/")
      result = rack_attack.blocklists["block_blank_agents"].block.call request

      expect(result).to be(false)
    end

    it "answers throttled response" do
      expect(rack_attack.throttled_responder.call).to eq([503, {}, ["Server Error"]])
    end

    it "answers throttles" do
      expect(rack_attack.throttles).to match(
        "ip" => kind_of(Rack::Attack::Throttle),
        "login" => kind_of(Rack::Attack::Throttle),
        "api_setup" => kind_of(Rack::Attack::Throttle)
      )
    end

    it "answers email (without spaces) when throttled login path and verb match" do
      allow(request).to receive_messages(
        params: {"login" => "test @ test.io"},
        path: "/login",
        post?: true
      )

      expect(rack_attack.throttles["login"].block.call(request)).to eq("test@test.io")
    end

    it "answers nil when throttled login path and verb don't match" do
      allow(request).to receive_messages(params: {}, path: "/login", post?: false)
      expect(rack_attack.throttles["login"].block.call(request)).to be(nil)
    end

    it "answers IP address when throttled API setup path matches" do
      allow(request).to receive_messages(ip: "1.2.3.4", path: "/api/setup")
      expect(rack_attack.throttles["api_setup"].block.call(request)).to eq("1.2.3.4")
    end

    it "answers nil when throttled API setup path doesn't match" do
      allow(request).to receive_messages(ip: "1.2.3.4", path: "/api/other")
      expect(rack_attack.throttles["api_setup"].block.call(request)).to be(nil)
    end
  end
end
