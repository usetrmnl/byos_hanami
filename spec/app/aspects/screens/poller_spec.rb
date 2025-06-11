# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Poller, :db do
  subject(:poller) { described_class.new client:, synchronizer:, kernel: }

  let(:kernel) { class_spy Kernel, sleep: nil }
  let(:client) { instance_spy TRMNL::API::Client, display: Success(display) }

  let :display do
    TRMNL::API::Models::Display[image_url: "https://test.io/test.bmp", filename: "test.bmp"]
  end

  let(:synchronizer) { instance_spy Terminus::Aspects::Screens::Synchronizer }

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
      expect(client).to have_received(:display)
    end

    it "downloads image" do
      poller.call
      expect(synchronizer).to have_received(:call).with(display)
    end

    context "with no devices" do
      let(:devices) { [] }

      it "doesn't download image" do
        poller.call
        expect(synchronizer).not_to have_received(:call)
      end
    end

    context "with no proxied devices" do
      let(:devices) { [Factory[:device]] }

      it "doesn't download image" do
        poller.call
        expect(synchronizer).not_to have_received(:call)
      end
    end

    context "with remote image failure" do
      let(:client) { instance_spy TRMNL::API::Client, display: Failure("Danger!") }

      it "doesn't download image" do
        poller.call
        expect(synchronizer).not_to have_received(:call)
      end
    end
  end
end
