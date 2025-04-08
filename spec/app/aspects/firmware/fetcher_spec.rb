# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Firmware::Fetcher do
  using Refinements::Pathname

  subject(:finder) { described_class.new settings: }

  include_context "with temporary directory"

  let(:settings) { Hanami.app[:settings] }

  before { allow(settings).to receive(:firmware_root).and_return temp_dir }

  describe "#call" do
    it "answers latest firmware version" do
      temp_dir.join("1.0.1.bin").touch
      temp_dir.join("1.0.0.bin").touch

      expect(finder.call).to eq(temp_dir.join("1.0.1.bin"))
    end

    it "answers root path when no files exist" do
      expect(finder.call).to be(temp_dir)
    end
  end
end
