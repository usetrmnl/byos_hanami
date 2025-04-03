# frozen_string_literal: true

require "hanami_helper"
require "versionaire"

RSpec.describe Terminus::HTTP::Headers::Parser do
  using Versionaire::Cast

  subject(:parser) { described_class.new }

  include_context "with firmware headers"

  describe "#call" do
    it "answers header record when success" do
      expect(parser.call(firmware_headers)).to be_success(
        Terminus::HTTP::Headers::Model[
          host: "https://localhost",
          user_agent: "ESP32HTTPClient",
          mac_address: "A1:B2:C3:D4:E5:F6",
          api_key: "abc123",
          refresh_rate: 25,
          battery: 4.74,
          firmware_version: Version("1.2.3"),
          wifi: -54,
          width: 800,
          height: 480
        ]
      )
    end

    it "answers failure with invalid headers" do
      firmware_headers.delete "HTTP_ID"

      expect(parser.call(firmware_headers)).to be_failure(
        Terminus::HTTP::Headers::Contract.call(firmware_headers)
      )
    end
  end
end
