# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::API::Headers::Contract do
  using Versionaire::Cast

  subject(:contract) { described_class }

  include_context "with firmware headers"

  describe ".call" do
    it "answers valid contract" do
      expect(contract.call(firmware_headers).to_h).to eq(
        HTTP_ACCESS_TOKEN: "abc123",
        HTTP_BATTERY_VOLTAGE: 4.74,
        HTTP_FW_VERSION: Version("1.2.3"),
        HTTP_HOST: "https://localhost",
        HTTP_ID: "A1:B2:C3:D4:E5:F6",
        HTTP_REFRESH_RATE: 25,
        HTTP_RSSI: -54,
        HTTP_USER_AGENT: "ESP32HTTPClient",
        HTTP_WIDTH: 800,
        HTTP_HEIGHT: 480
      )
    end
  end
end
