# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::API::Display::Show, :db do
  using Refinements::Pathname

  subject :action do
    described_class.new settings:, fetcher: Terminus::Aspects::Screens::Rotator.new(settings:)
  end

  include_context "with firmware headers"
  include_context "with temporary directory"

  let(:settings) { Hanami.app[:settings] }

  describe "#call" do
    let(:device) { Factory[:device] }

    before do
      firmware_headers["HTTP_ACCESS_TOKEN"] = device.api_key
      allow(settings).to receive(:screens_root).and_return(temp_dir)

      SPEC_ROOT.join("support/fixtures/test.bmp").copy temp_dir.join("test.bmp")
    end

    it "answers payload with valid parameters and full dependencies" do
      action = described_class.new(settings:)
      response = Rack::MockRequest.new(action).get "/api/display", firmware_headers
      payload = JSON response.body, symbolize_names: true

      expect(payload).to include(
        filename: /.+\.bmp/,
        firmware_url: nil,
        image_url: %r(http://.+/assets/screens/.+\.bmp),
        image_url_timeout: 0,
        refresh_rate: 900,
        reset_firmware: false,
        special_function: "sleep",
        update_firmware: false
      )
    end

    context "with custom device attributes" do
      let(:device) { Factory[:device, image_timeout: 10, refresh_rate: 20] }

      it "answers payload with custom device attributes" do
        action = described_class.new(settings:)
        response = Rack::MockRequest.new(action).get "/api/display", firmware_headers
        payload = JSON response.body, symbolize_names: true

        expect(payload).to include(
          filename: /.+\.bmp/,
          firmware_url: nil,
          image_url: %r(http://.+/assets/screens/.+\.bmp),
          image_url_timeout: 10,
          refresh_rate: 20,
          reset_firmware: false,
          special_function: "sleep",
          update_firmware: false
        )
      end
    end

    it "answers image for valid access token" do
      response = Rack::MockRequest.new(action).get "/api/display", firmware_headers
      payload = JSON response.body, symbolize_names: true

      expect(payload).to include(
        filename: /.+\.bmp/,
        firmware_url: nil,
        image_url: %r(http://.+/assets/screens/.+\.bmp),
        image_url_timeout: 0,
        refresh_rate: 900,
        reset_firmware: false,
        special_function: "sleep",
        update_firmware: false
      )
    end

    it "answers image data for valid access token and Base 64 header" do
      firmware_headers["HTTP_BASE64"] = "true"
      response = Rack::MockRequest.new(action).get "/api/display", firmware_headers
      payload = JSON response.body, symbolize_names: true

      expect(payload).to include(
        filename: /.+\.bmp/,
        firmware_url: nil,
        image_url: %r(data:image/bmp;base64.+),
        image_url_timeout: 0,
        refresh_rate: 900,
        reset_firmware: false,
        special_function: "sleep",
        update_firmware: false
      )
    end

    it "answers image data for valid access token and Base 64 parameter" do
      response = Rack::MockRequest.new(action).get "/api/display",
                                                   **firmware_headers,
                                                   params: {base_64: true}
      payload = JSON response.body, symbolize_names: true

      expect(payload).to include(
        filename: /.+\.bmp/,
        firmware_url: nil,
        image_url: %r(data:image/bmp;base64.+),
        image_url_timeout: 0,
        refresh_rate: 900,
        reset_firmware: false,
        special_function: "sleep",
        update_firmware: false
      )
    end

    it "answers 200 OK status with valid parameters" do
      response = Rack::MockRequest.new(action).get "/api/display", firmware_headers
      expect(response.status).to eq(200)
    end

    it "answers not found for index with invalid access token" do
      response = action.call Hash.new
      expect(response.status).to eq(404)
    end
  end
end
