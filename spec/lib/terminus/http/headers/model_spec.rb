# frozen_string_literal: true

require "hanami_helper"
require "versionaire"

RSpec.describe Terminus::HTTP::Headers::Model do
  using Refinements::Hash
  using Versionaire::Cast

  subject :record do
    described_class[
      host: "https://localhost",
      user_agent: "ESP32HTTPClient",
      mac_address: "A1:B2:C3:D4:E5:F6",
      access_token: "abc123",
      refresh_rate: 25,
      battery: 4.74,
      firmware_version: Version("1.2.3"),
      signal: -40,
      width: 800,
      height: 480
    ]
  end

  include_context "with firmware headers"

  describe ".for" do
    it "answers record for raw HTTP headers" do
      record = described_class.for firmware_headers.symbolize_keys!

      expect(record).to eq(
        described_class[
          host: "https://localhost",
          user_agent: "ESP32HTTPClient",
          mac_address: "A1:B2:C3:D4:E5:F6",
          access_token: "abc123",
          refresh_rate: "25",
          battery: "4.74",
          firmware_version: "1.2.3",
          signal: "-54",
          width: "800",
          height: "480"
        ]
      )
    end
  end

  describe "#device_attributes" do
    it "answers device attributes" do
      expect(record.device_attributes).to eq(
        battery: 4.74,
        firmware_version: "1.2.3",
        signal: -40,
        width: 800,
        height: 480
      )
    end
  end
end
