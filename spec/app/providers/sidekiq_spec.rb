# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Providers::Sidekiq do
  subject(:provider) { described_class.new provider_container:, target_container:, slice: }

  let(:provider_container) { Dry::Core::Container.new }
  let(:target_container) { Dry::Core::Container.new }
  let(:slice) { Hanami.app }

  describe "#prepare" do
    it "answers false due to already being loaded" do
      expect(provider.prepare).to be(false)
    end
  end

  describe "#start" do
    subject :provider do
      described_class.new resolver: proc { sidekiq }, provider_container:, target_container:, slice:
    end

    let(:sidekiq) { Sidekiq }

    it "configures client" do
      provider.start
      ping = nil
      sidekiq.redis { ping = it.ping }

      expect(ping).to eq("PONG")
    end

    it "configures client logger" do
      provider.start
      expect(sidekiq.logger).to be_a(Cogger::Hub)
    end
  end
end
