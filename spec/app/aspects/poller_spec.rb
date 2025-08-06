# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Poller do
  subject(:poller) { described_class.new "firmware", synchronizer, kernel: }

  let(:synchronizer) { proc { Success "Finished." } }
  let(:kernel) { class_spy Kernel, sleep: 0 }

  include_context "with main application"
  include_context "with library dependencies"

  describe "#call" do
    before { allow(kernel).to receive(:loop).and_yield }

    it "logs CONTROL+C shutdown" do
      allow(kernel).to receive(:trap).and_yield
      poller.call seconds: 30

      expect(logger.reread).to match(/INFO.+Gracefully shutting down firmware polling\.\.\./)
    end

    it "gracefully exists when CONTROL+C is used" do
      allow(kernel).to receive(:trap).and_yield
      poller.call seconds: 30

      expect(kernel).to have_received(:exit)
    end

    it "logs synchronization success" do
      poller.call seconds: 30
      expect(logger.reread).to match(/INFO/)
    end

    it "logs info when disabled" do
      allow(settings).to receive(:firmware_poller).and_return false
      poller.call seconds: 30

      expect(logger.reread).to match(/INFO.+Firmware polling disabled\./)
    end

    it "logs fatal when synchronization result can't be processed" do
      synchronizer = proc { "Danger!" }
      poller = described_class.new(:firmware, synchronizer, kernel:)

      poller.call seconds: 30

      expect(logger.reread).to match(/FATAL.+Unable to synchronize\./)
    end
  end
end
