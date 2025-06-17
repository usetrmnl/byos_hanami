# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "/api/setup", :db do
  using Refinements::Pathname

  let(:device) { Factory[:device] }
  let(:repository) { Terminus::Repositories::Device.new }

  include_context "with main application"

  context "without devices" do
    let(:mac_address) { "AA:BB:CC:00:11:22" }
    let(:device) { repository.find_by_mac_address mac_address }

    it "answers device/image details for new device" do
      get routes.path(:api_setup), {}, "HTTP_ID" => mac_address, "HTTP_FW_VERSION" => "1.2.3"

      expect(json_payload).to eq(
        api_key: device.api_key,
        friendly_id: device.friendly_id,
        image_url: %(#{settings.api_uri}/assets/setup.bmp),
        message: "Welcome to Terminus!"
      )
    end

    it "creates device" do
      get routes.path(:api_setup), {}, "HTTP_ID" => mac_address, "HTTP_FW_VERSION" => "1.2.3"

      expect(device).to have_attributes(
        label: "TRMNL",
        friendly_id: /[A-Z0-9]{6}/,
        mac_address:,
        firmware_version: "1.2.3",
        api_key: /[a-z0-9]{20}/i
      )
    end

    it "creates welcome screen" do
      get routes.path(:api_setup), {}, "HTTP_ID" => mac_address, "HTTP_FW_VERSION" => "1.2.3"
      expect(temp_dir.join("AABBCC001122/setup.png").exist?).to be(true)
    end
  end

  it "answers existing device for MAC address" do
    get routes.path(:api_setup), {}, "HTTP_ID" => device.mac_address

    expect(json_payload).to eq(
      api_key: device.api_key,
      friendly_id: device.friendly_id,
      image_url: %(#{settings.api_uri}/assets/setup.bmp),
      message: "Welcome to Terminus!"
    )
  end

  it "answers error when firmware version header is invalid" do
    get routes.path(:api_setup), {}, "HTTP_ID" => device.mac_address, "HTTP_FW_VERSION" => "abc"

    problem = Petail[
      type: "/problem_details#device_setup",
      status: :unprocessable_entity,
      detail: "Invalid request headers.",
      instance: "/api/setup",
      extensions: {
        HTTP_FW_VERSION: ["is in invalid format"]
      }
    ]

    expect(json_payload).to eq(problem.to_h)
  end

  it "answers error when device ID header is invalid" do
    get routes.path(:api_setup), {}, "HTTP_ID" => "bogus"

    problem = Petail[
      type: "/problem_details#device_setup",
      status: :unprocessable_entity,
      detail: "Invalid request headers.",
      instance: "/api/setup",
      extensions: {
        HTTP_ID: ["is in invalid format"]
      }
    ]

    expect(json_payload).to eq(problem.to_h)
  end

  it "answers error when device headers are missing" do
    get routes.path(:api_setup), {}

    problem = Petail[
      type: "/problem_details#device_setup",
      status: :unprocessable_entity,
      detail: "Invalid request headers.",
      instance: "/api/setup",
      extensions: {
        HTTP_ID: ["is missing"]
      }
    ]

    expect(json_payload).to eq(problem.to_h)
  end
end
