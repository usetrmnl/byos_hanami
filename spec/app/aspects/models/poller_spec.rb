# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Models::Poller do
  subject(:poller) { described_class.new synchronizer:, kernel: }

  let(:synchronizer) { instance_spy Terminus::Aspects::Models::Synchronizer }
  let(:kernel) { class_spy Kernel, sleep: 0 }

  include_context "with main application"

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

    it "synchronizes" do
      poller.call
      expect(synchronizer).to have_received(:call)
    end

    context "when disabled" do
      before do
        allow(settings).to receive(:model_poller).and_return false
        poller.call
      end

      it "prints message" do
        expect(kernel).to have_received(:puts).with("Model polling disabled.")
      end

      it "doesn't synchronize" do
        expect(synchronizer).not_to have_received(:call)
      end
    end
  end
end
