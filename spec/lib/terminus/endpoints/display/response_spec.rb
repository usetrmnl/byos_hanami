# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Endpoints::Display::Response do
  subject(:model) { described_class.new }

  describe ".for" do
    let :attributes do
      {
        filename: "test.bmp",
        firmware_url: "https://test.io/FW1.4.8.bin",
        image_url: "https://test.io/images/test.bmp",
        refresh_rate: 3200,
        reset_firmware: false,
        special_function: "restart_playlist",
        update_firmware: true
      }
    end

    it "answers record for attributes" do
      expect(described_class.for(attributes)).to eq(described_class[**attributes])
    end
  end

  describe "#initialize" do
    it "answers default attributes" do
      expect(model.to_h).to eq(
        filename: nil,
        firmware_url: nil,
        image_url: nil,
        image_url_timeout: 0,
        refresh_rate: 300,
        reset_firmware: false,
        special_function: "sleep",
        update_firmware: false
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
        filename: nil,
        firmware_url: nil,
        image_url: nil,
        image_url_timeout: 0,
        refresh_rate: 300,
        reset_firmware: false,
        special_function: "sleep",
        update_firmware: false
      )
    end
  end
end
