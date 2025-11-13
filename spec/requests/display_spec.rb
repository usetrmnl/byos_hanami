# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "/api/display", :db do
  using Refinements::Pathname

  include_context "with firmware headers"

  let :device do
    provisioner.call(model_id: Factory[:model].id, mac_address: "A1:B2:C3:D4:E5:F6").value!
  end

  let(:provisioner) { Terminus::Aspects::Devices::Provisioner.new }
  let(:device_repository) { Terminus::Repositories::Device.new }
  let(:firmware) { Factory[:firmware, :with_attachment] }

  it "answers payload with all atttributes" do
    device
    firmware
    get routes.path(:api_display), {}, **firmware_headers

    expect(json_payload).to include(
      filename: /terminus_welcome_#{device.friendly_id.downcase}-\h{32}\.png/,
      firmware_url: "memory://abc123.bin",
      image_url: %r(memory://\h{32}\.png),
      image_url_timeout: 0,
      refresh_rate: 900,
      reset_firmware: false,
      special_function: "sleep",
      update_firmware: false
    )
  end

  it "answers payload with custom device attributes" do
    device_repository.update device.id, image_timeout: 10, refresh_rate: 20
    firmware
    get routes.path(:api_display), {}, **firmware_headers

    expect(json_payload).to include(
      filename: /terminus_welcome_#{device.friendly_id.downcase}-\h{32}\.png/,
      firmware_url: "memory://abc123.bin",
      image_url: %r(memory://\h{32}\.png),
      image_url_timeout: 10,
      refresh_rate: 20,
      reset_firmware: false,
      special_function: "sleep",
      update_firmware: false
    )
  end

  it "answers image data for valid Base 64 header" do
    device
    firmware
    firmware_headers["HTTP_BASE64"] = "true"

    get routes.path(:api_display), {}, **firmware_headers

    expect(json_payload).to include(
      filename: /terminus_welcome_#{device.friendly_id.downcase}-\h{32}\.png/,
      firmware_url: "memory://abc123.bin",
      image_url: %r(data:image/png;base64.+),
      image_url_timeout: 0,
      refresh_rate: 900,
      reset_firmware: false,
      special_function: "sleep",
      update_firmware: false
    )
  end

  it "answers image data for valid Base 64 parameter" do
    device
    firmware
    get routes.path(:api_display), {base_64: true}, **firmware_headers

    expect(json_payload).to include(
      filename: /terminus_welcome_#{device.friendly_id.downcase}-\h{32}\.png/,
      firmware_url: "memory://abc123.bin",
      image_url: %r(data:image/png;base64.+),
      image_url_timeout: 0,
      refresh_rate: 900,
      reset_firmware: false,
      special_function: "sleep",
      update_firmware: false
    )
  end

  it "removes firmware URI when device and latest firmware versions match" do
    device_repository.update device.id, firmware_version: "1.2.3"
    Factory[:firmware, :with_attachment, version: "1.2.3"]
    get routes.path(:api_display), {}, **firmware_headers

    expect(json_payload).to include(
      filename: /terminus_welcome_#{device.friendly_id.downcase}-\h{32}\.png/,
      firmware_url: nil,
      image_url: %r(memory://\h{32}\.png),
      image_url_timeout: 0,
      refresh_rate: 900,
      reset_firmware: false,
      special_function: "sleep",
      update_firmware: false
    )
  end

  it "removes firmware URI when firmware doesn't exist" do
    device
    get routes.path(:api_display), {}, **firmware_headers

    expect(json_payload).to include(
      filename: /terminus_welcome_#{device.friendly_id.downcase}-\h{32}\.png/,
      firmware_url: nil,
      image_url: %r(memory://\h{32}\.png),
      image_url_timeout: 0,
      refresh_rate: 900,
      reset_firmware: false,
      special_function: "sleep",
      update_firmware: false
    )
  end

  context "with invalid/missing headers" do
    before { get routes.path(:api_display) }

    it "answers not found problem details" do
      problem = Petail[
        type: "/problem_details#device_id",
        status: :not_found,
        detail: "Invalid device ID.",
        instance: "/api/display"
      ]

      expect(json_payload).to eq(problem.to_h)
    end
  end

  context "with no device" do
    before { get routes.path(:api_display), {}, **firmware_headers }

    it "answers problem details" do
      problem = Petail[
        type: "/problem_details#device_id",
        status: :not_found,
        detail: "Invalid device ID.",
        instance: "/api/display"
      ]

      expect(json_payload).to eq(problem.to_h)
    end

    it "answers content type and status" do
      expect(last_response).to have_attributes(
        content_type: "application/problem+json; charset=utf-8",
        status: 404
      )
    end
  end

  context "with any error" do
    let(:device) { Factory[:device] }

    before do
      device
      get routes.path(:api_display), {}, **firmware_headers
    end

    it "answers error image" do
      expect(json_payload).to include(
        filename: "#{device.screen_name :error}.png",
        firmware_url: nil,
        image_url: %r(memory://\h{32}\.png),
        image_url_timeout: 0,
        refresh_rate: 900,
        reset_firmware: false,
        special_function: "sleep",
        update_firmware: false
      )
    end

    it "answers content type and OK status" do
      expect(last_response).to have_attributes(
        content_type: "application/json; charset=utf-8",
        status: 200
      )
    end
  end
end
