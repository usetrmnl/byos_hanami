# frozen_string_literal: true

require "hanami_helper"
require "trmnl/api"

RSpec.describe Terminus::Aspects::Screens::Poller, :db do
  subject(:poller) { described_class.new trmnl_api:, synchronizer:, kernel: }

  let(:trmnl_api) { instance_spy TRMNL::API::Client, display: Success(display) }
  let(:kernel) { class_spy Kernel, sleep: nil }

  let :display do
    TRMNL::API::Models::Display[image_url: "https://test.io/test.bmp", filename: "test.bmp"]
  end

  let(:synchronizer) { instance_spy Terminus::Aspects::Screens::Synchronizer }

  include_context "with main application"

  describe "#call" do
    let(:devices) { [Factory[:device, proxy: true]] }

    before do
      devices
      allow(kernel).to receive(:loop).and_yield
    end

    it "prints that it's shutting down when CONTROL+C is used" do
      allow(kernel).to receive(:trap).and_yield
      poller.call

      expect(kernel).to have_received(:puts).with(/shutting down/)
    end

    it "gracefully exists when CONTROL+C is used" do
      allow(kernel).to receive(:trap).and_yield
      poller.call

      expect(kernel).to have_received(:exit)
    end

    it "requests image for device API key" do
      poller.call
      expect(trmnl_api).to have_received(:display)
    end

    it "synchronizes" do
      poller.call
      expect(synchronizer).to have_received(:call).with(display)
    end

    context "with no devices" do
      let(:devices) { [] }

      it "doesn't synchronize" do
        poller.call
        expect(synchronizer).not_to have_received(:call)
      end
    end

    context "with no proxied devices" do
      let(:devices) { [Factory[:device]] }

      it "doesn't synchronize" do
        poller.call
        expect(synchronizer).not_to have_received(:call)
      end
    end

    context "with remote image failure" do
      let(:trmnl_api) { instance_spy TRMNL::API::Client, display: Failure("Danger!") }

      it "doesn't synchronize" do
        poller.call
        expect(synchronizer).not_to have_received(:call)
      end
    end

    context "when disabled" do
      before do
        allow(settings).to receive(:screen_poller).and_return false
        poller.call
      end

      it "prints message" do
        expect(kernel).to have_received(:puts).with("Screen polling disabled.")
      end

      it "doesn't synchronize" do
        expect(synchronizer).not_to have_received(:call)
      end
    end
  end
end
