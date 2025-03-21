# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::API::Responses::Display do
  subject(:model) { described_class.new }

  describe "#initialize" do
    it "answers default attributes" do
      expect(model.to_h).to eq(
        filename: nil,
        firmware_url: nil,
        image_url: nil,
        refresh_rate: 300,
        reset_firmware: false,
        special_function: "sleep",
        status: 404,
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
        refresh_rate: 300,
        reset_firmware: false,
        special_function: "sleep",
        status: 404,
        update_firmware: false
      )
    end
  end
end
