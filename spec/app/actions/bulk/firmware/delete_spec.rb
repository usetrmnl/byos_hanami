# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Bulk::Firmware::Delete do
  using Refinements::Pathname

  subject(:action) { described_class.new }

  include_context "with main application"

  describe "#call" do
    it "deletes all firmware" do
      settings.firmware_root.join("0.0.0.bin").touch
      action.call Hash.new

      expect(settings.firmware_root.empty?).to be(true)
    end

    it "answers no firmware when success" do
      response = action.call Hash.new
      expect(response.body.first).to include("No firmware found.")
    end

    context "with deletion error" do
      subject(:action) { described_class.new fetcher: }

      let(:fetcher) { instance_double Terminus::Aspects::Firmware::Fetcher }

      before { allow(fetcher).to receive(:call).and_raise(Errno::ENOENT) }

      it "answers error when firmware can't be deleted" do
        response = action.call Hash.new
        expect(response.body.first).to include("Unable to delete firmware.")
      end

      it "answers internal server error status" do
        response = action.call Hash.new
        expect(response.status).to eq(500)
      end
    end
  end
end
