# frozen_string_literal: true

RSpec.shared_context "with fake HTTP current screen" do
  let :http do
    HTTP::Fake::Client.new do
      get "/api/current_screen" do
        headers["Content-Type"] = "application/json"
        status 200

        <<~JSON
          {
            "status": 200,
            "refresh_rate": 3200,
            "image_url": "https://test.io/images/test.bmp",
            "filename": "test.bmp",
            "rendered_at": null
          }
        JSON
      end
    end
  end
end
