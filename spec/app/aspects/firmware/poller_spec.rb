# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Firmware::Poller do
  using Refinements::Pathname

  subject(:poller) { described_class.new downloader:, kernel: }

  include_context "with temporary directory"

  let(:downloader) { instance_spy Terminus::Aspects::Firmware::Downloader }
  let(:kernel) { class_spy Kernel, sleep: 0 }

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
  end
end
