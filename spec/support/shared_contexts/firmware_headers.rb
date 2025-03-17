# frozen_string_literal: true

RSpec.shared_context "with firmware headers" do
  let :firmware_headers do
    {
      "HTTP_HOST" => "https://localhost",
      "HTTP_USER_AGENT" => "ESP32HTTPClient",
      "HTTP_ID" => "A1:B2:C3:D4:E5:F6",
      "HTTP_ACCESS_TOKEN" => "abc123",
      "HTTP_REFRESH_RATE" => "25",
      "HTTP_BATTERY_VOLTAGE" => "4.74",
      "HTTP_FW_VERSION" => "1.2.3",
      "HTTP_RSSI" => "-54",
      "HTTP_WIDTH" => "800",
      "HTTP_HEIGHT" => "480"
    }
  end
end
