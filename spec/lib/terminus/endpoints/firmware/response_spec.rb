# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Endpoints::Firmware::Response do
  describe ".for" do
    it "answers record for attributes" do
      attributes = {url: "https://test.io/FW1.0.0.bin", version: "1.0.0"}
      expect(described_class.for(attributes)).to eq(described_class[**attributes])
    end
  end
end
