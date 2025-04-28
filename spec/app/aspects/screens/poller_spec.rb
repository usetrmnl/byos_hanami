# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Poller, :db do
  subject(:poller) { described_class.new endpoint:, downloader:, kernel:, logger: }

  let(:kernel) { class_spy Kernel, sleep: nil }

  let :endpoint do
    instance_spy TRMNL::API::Endpoints::Display,
                 call: Success(
                   TRMNL::API::Models::Display[
                     image_url: "https://test.io/test.bmp",
                     filename: "test.bmp"
                   ]
                 )
  end

  let(:downloader) { instance_spy Terminus::Aspects::Screens::Downloader }
  let(:logger) { instance_spy Dry::Logger::Dispatcher }

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
      expect(endpoint).to have_received(:call)
    end

    it "downloads image" do
      poller.call

      expect(downloader).to have_received(:call).with(
        "https://test.io/test.bmp",
        "#{devices.first.slug}/test.bmp"
      )
    end

    it "logs successful file download" do
      allow(downloader).to receive(:call).and_return(Success("test/path"))
      poller.call

      expect(logger).to have_received(:info).with("Downloaded: test/path.")
    end

    it "logs download failure" do
      allow(downloader).to receive(:call).and_return(Failure("Danger!"))
      poller.call

      expect(logger).to have_received(:error).with("Danger!")
    end

    it "logs download failure for unknown type" do
      allow(downloader).to receive(:call).and_return("Danger!")
      poller.call

      expect(logger).to have_received(:error).with("Unable to download firmware.")
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
        instance_spy TRMNL::API::Endpoints::Display, call: Failure("Danger!")
      end

      it "doesn't download image" do
        poller.call
        expect(downloader).not_to have_received(:call)
      end
    end
  end
end
