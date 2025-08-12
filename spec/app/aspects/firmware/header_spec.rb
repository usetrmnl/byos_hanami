# frozen_string_literal: true

require "hanami_helper"
require "versionaire"

RSpec.describe Terminus::Aspects::Firmware::Header do
  using Versionaire::Cast

  subject(:parser) { described_class.new }

  include_context "with firmware headers"
  include_context "with library dependencies"

  describe "#call" do
    let :debug_message_pattern do
      /
        DEBUG.+
        \[HTTP_ACCESS_TOKEN=.+\]\s
        \[HTTP_BATTERY_VOLTAGE=.+]\s
        \[HTTP_FW_VERSION=.+]\s
        \[HTTP_HEIGHT=.+]\s
        \[HTTP_HOST=.+]\s
        \[HTTP_ID=.+]\s
        \[HTTP_REFRESH_RATE=.+]\s
        \[HTTP_RSSI=.+]\s
        \[HTTP_USER_AGENT=.+]\s
        \[HTTP_WIDTH=.+]\s
        Processing\sdevice\srequest\sheaders\.
      /x
    end

    it "logs header information as debug message" do
      parser.call firmware_headers
      expect(logger.reread).to match(debug_message_pattern)
    end

    it "answers header record when success" do
      expect(parser.call(firmware_headers)).to be_success(
        Terminus::Models::Firmware::Header[
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
        Terminus::Contracts::Firmware::Header.call(firmware_headers)
      )
    end
  end
end
