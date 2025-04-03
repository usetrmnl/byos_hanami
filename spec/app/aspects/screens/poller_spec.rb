# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Poller, :db do
  subject(:poller) { described_class.new repository:, endpoint:, downloader:, kernel: }

  let(:repository) { instance_double Terminus::Repositories::Device, all: devices }
  let(:devices) { [Factory[:device, api_key: "abc123", proxy: true]] }
  let(:kernel) { class_double Kernel, sleep: nil }

  let :endpoint do
    instance_spy Terminus::Endpoints::Display::Requester,
                 call: Success(
                   Terminus::Endpoints::Display::Response[
                     image_url: "https://test.io/test.bmp",
                     filename: "test.bmp"
                   ]
                 )
  end

  let(:downloader) { instance_spy Terminus::Aspects::Screens::Downloader }

  describe "#call" do
    before { allow(kernel).to receive(:loop).and_yield }

    it "requests image for device API key" do
      poller.call
      expect(endpoint).to have_received(:call).with api_key: "abc123"
    end

    it "downloads image" do
      poller.call
      expect(downloader).to have_received(:call).with "https://test.io/test.bmp", "test.bmp"
    end

    context "with no devices" do
      let(:devices) { [] }

      it "doesn't download image" do
        poller.call
        expect(downloader).not_to have_received(:call)
      end
    end

    context "with no proxied devices" do
      let(:devices) { [Factory[:device]] }

      it "doesn't download image" do
        poller.call
        expect(downloader).not_to have_received(:call)
      end
    end

    context "with remote image failure" do
      let :endpoint do
        instance_spy Terminus::Endpoints::Display::Requester, call: Failure("Danger!")
      end

      it "doesn't download image" do
        poller.call
        expect(downloader).not_to have_received(:call)
      end
    end
  end
end
