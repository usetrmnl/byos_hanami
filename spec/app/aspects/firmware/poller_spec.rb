# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Firmware::Poller do
  using Refinements::Pathname

  subject(:poller) { described_class.new downloader:, kernel:, logger: }

  include_context "with temporary directory"

  let(:downloader) { instance_spy Terminus::Aspects::Firmware::Downloader }
  let(:kernel) { class_spy Kernel, sleep: 0 }
  let(:logger) { instance_spy Dry::Logger::Dispatcher }

  describe "#call" do
    before { allow(kernel).to receive(:loop).and_yield }

    it "prints shutting down when CONTROL+C is used" do
      allow(kernel).to receive(:trap).and_yield
      poller.call

      expect(kernel).to have_received(:puts).with(/shutting down/)
    end

    it "gracefully exists when CONTROL+C is used" do
      allow(kernel).to receive(:trap).and_yield
      poller.call

      expect(kernel).to have_received(:exit)
    end

    it "downloads file" do
      poller.call
      expect(downloader).to have_received(:call)
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
  end
end
