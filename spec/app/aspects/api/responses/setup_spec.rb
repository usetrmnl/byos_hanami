# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::API::Responses::Setup, :db do
  subject(:model) { described_class.new }

  describe ".for" do
    it "answers record for device" do
      device = Factory[:device]

      expect(described_class.for(device)).to eq(
        described_class[
          api_key: "abc123",
          friendly_id: "ABC123",
          image_url: %(#{Hanami.app[:settings].api_uri}/assets/setup.bmp),
          message: "Welcome to TRMNL BYOS."
        ]
      )
    end
  end

  describe "#initialize" do
    it "answers default attributes" do
      expect(model.to_h).to eq(
        api_key: nil,
        friendly_id: nil,
        image_url: nil,
        message: "MAC Address not registered."
      )
    end

    it "is frozen" do
      expect(model.frozen?).to be(true)
    end
  end

  describe "#to_json" do
    it "answers JSON" do
      payload = JSON model.to_json, symbolize_names: true

      expect(payload).to eq(
        api_key: nil,
        friendly_id: nil,
        image_url: nil,
        message: "MAC Address not registered."
      )
    end
  end
end
