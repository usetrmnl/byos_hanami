# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "/api/display", :db do
  using Refinements::Pathname

  let(:device) { Factory[:device] }

  include_context "with firmware headers"

  before do
    temp_dir.join("0.0.0.bin").touch

    SPEC_ROOT.join("support/fixtures/test.bmp")
             .copy temp_dir.join("#{device.slug}/test.bmp").make_ancestors
  end

  it "answers payload with valid parameters and full dependencies" do
    get routes.path(:api_display_show), {}, **firmware_headers

    expect(json_payload).to include(
      filename: /.+\.bmp/,
      firmware_url: /.*0\.0\.0\.bin/,
      image_url: %r(https://.+/assets/screens/A1B2C3D4E5F6.+\.bmp),
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
      get routes.path(:api_display_show), {}, **firmware_headers

      expect(json_payload).to include(
        filename: /.+\.bmp/,
        firmware_url: /.*0\.0\.0\.bin/,
        image_url: %r(https://.+/assets/screens/A1B2C3D4E5F6.+\.bmp),
        image_url_timeout: 10,
        refresh_rate: 20,
        reset_firmware: false,
        special_function: "sleep",
        update_firmware: false
      )
    end
  end

  it "answers image data for valid access token and Base 64 header" do
    firmware_headers["HTTP_BASE64"] = "true"

    get routes.path(:api_display_show), {}, **firmware_headers

    expect(json_payload).to include(
      filename: /.+\.bmp/,
      firmware_url: /.*0\.0\.0\.bin/,
      image_url: %r(data:image/bmp;base64.+),
      image_url_timeout: 0,
      refresh_rate: 900,
      reset_firmware: false,
      special_function: "sleep",
      update_firmware: false
    )
  end

  it "answers image data for valid access token and Base 64 parameter" do
    get routes.path(:api_display_show), {base_64: true}, **firmware_headers

    expect(json_payload).to include(
      filename: /.+\.bmp/,
      firmware_url: /\d+\.\d+\.\d+\.bin/,
      image_url: %r(data:image/bmp;base64.+),
      image_url_timeout: 0,
      refresh_rate: 900,
      reset_firmware: false,
      special_function: "sleep",
      update_firmware: false
    )
  end

  it "answers not found for index with invalid access token" do
    get routes.path(:api_display_show)
    expect(last_response.status).to eq(404)
  end
end
