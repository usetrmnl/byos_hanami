# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::API::Display::Show, :db do
  using Refinements::Pathname

  subject(:action) { described_class.new settings: }

  include_context "with temporary directory"

  let(:settings) { Hanami.app[:settings] }

  describe "#call" do
    let(:device) { Factory[:device] }

    before do
      allow(settings).to receive(:images_root).and_return(temp_dir)

      SPEC_ROOT.join("support/fixtures/test.bmp")
               .copy temp_dir.join("generated/test.bmp").make_ancestors
    end

    it "answers 200 OK status with valid parameters" do
      response = Rack::MockRequest.new(action).get "/api/display",
                                                   "HTTP_ACCESS_TOKEN" => device.api_key

      expect(response.status).to eq(200)
    end

    it "answers image for valid access token" do
      response = Rack::MockRequest.new(action).get "/api/display",
                                                   "HTTP_ACCESS_TOKEN" => device.api_key
      payload = JSON response.body, symbolize_names: true

      expect(payload).to include(
        filename: /.+\.bmp/,
        firmware_url: nil,
        image_url: %r(https://localhost/assets/images/generated/.+\.bmp),
        refresh_rate: 900,
        reset_firmware: false,
        special_function: "sleep",
        status: 0,
        update_firmware: false
      )
    end

    it "answers image data for valid access token and base 64 header" do
      response = Rack::MockRequest.new(action).get "/api/display",
                                                   "HTTP_ACCESS_TOKEN" => device.api_key,
                                                   "HTTP_BASE64" => "true"
      payload = JSON response.body, symbolize_names: true

      expect(payload).to include(
        filename: /.+\.bmp/,
        firmware_url: nil,
        image_url: %r(data:image/bmp;base64.+),
        refresh_rate: 900,
        reset_firmware: false,
        special_function: "sleep",
        status: 0,
        update_firmware: false
      )
    end

    it "answers not found for index with invalid access token" do
      response = action.call Hash.new
      expect(response.status).to eq(404)
    end
  end
end
