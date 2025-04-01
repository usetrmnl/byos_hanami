# frozen_string_literal: true

RSpec.shared_context "with fake HTTP display" do
  let :http do
    HTTP::Fake::Client.new do
      get "/api/display" do
        headers["Content-Type"] = "application/json"
        status 200

        <<~JSON
          {
            "filename": "test.bmp",
            "firmware_url": "https://test.io/FW1.4.8.bin",
            "image_url": "https://test.io/images/test.bmp",
            "refresh_rate": 3200,
            "reset_firmware": false,
            "special_function": "restart_playlist",
            "status": 0,
            "update_firmware": true
          }
        JSON
      end
    end
  end
end
