# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "/api/setup", :db do
  let(:device) { Factory[:device, model_id: model.id] }
  let(:model) { Factory[:model, name: "og_png"] }

  it "answers new device when device doesn't exist" do
    model
    get routes.path(:api_setup), {}, "HTTP_ID" => "A1:B2:C3:D4:E5:F6", "HTTP_FW_VERSION" => "1.2.3"

    expect(json_payload).to match(
      api_key: match_device_api_key,
      friendly_id: match_device_friendly_id,
      image_url: %(#{settings.api_uri}/assets/setup.bmp),
      message: "Welcome to Terminus!"
    )
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

  it "answers problem details when model for device doesn't exist" do
    get routes.path(:api_setup), {}, "HTTP_ID" => "A1:B2:C3:D4:E5:F6", "HTTP_FW_VERSION" => "1.2.3"

    problem = Petail[
      type: "/problem_details#device_setup",
      status: :not_found,
      detail: %(Unable to find model for ID: nil.),
      instance: "/api/setup"
    ]

    expect(json_payload).to eq(problem.to_h)
  end

  it "answers problem details when firmware version header is invalid" do
    get routes.path(:api_setup), {}, "HTTP_ID" => device.mac_address, "HTTP_FW_VERSION" => "abc"

    problem = Petail[
      type: "/problem_details#device_setup",
      status: :unprocessable_content,
      detail: "Invalid request headers.",
      instance: "/api/setup",
      extensions: {
        errors: {
          HTTP_FW_VERSION: ["is in invalid format"]
        }
      }
    ]

    expect(json_payload).to eq(problem.to_h)
  end

  it "answers problem details when device ID header is invalid" do
    get routes.path(:api_setup), {}, "HTTP_ID" => "bogus"

    problem = Petail[
      type: "/problem_details#device_setup",
      status: :unprocessable_content,
      detail: "Invalid request headers.",
      instance: "/api/setup",
      extensions: {
        errors: {
          HTTP_ID: ["is in invalid format"]
        }
      }
    ]

    expect(json_payload).to eq(problem.to_h)
  end

  it "answers problem details when device headers are missing" do
    get routes.path(:api_setup), {}

    problem = Petail[
      type: "/problem_details#device_setup",
      status: :unprocessable_content,
      detail: "Invalid request headers.",
      instance: "/api/setup",
      extensions: {
        errors: {
          HTTP_ID: ["is missing"]
        }
      }
    ]

    expect(json_payload).to eq(problem.to_h)
  end
end
