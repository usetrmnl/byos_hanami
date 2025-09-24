# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "/api/devices", :db do
  include_context "with JWT"

  let(:device) { Factory[:device, model_id: model.id, playlist_id: playlist.id] }
  let(:model) { Factory[:model] }
  let(:playlist) { Factory[:playlist] }

  let :attributes do
    {
      model_id: model.id,
      playlist_id: nil,
      friendly_id: "ABC123",
      label: "Request Test",
      mac_address: "A1:B2:C3:D4:E5:F6",
      api_key: "abc123",
      firmware_beta: false,
      refresh_rate: 500,
      image_timeout: 5,
      proxy: true,
      firmware_update: true,
      sleep_start_at: "05:00:00+0000",
      sleep_stop_at: "10:00:00+0000"
    }
  end

  it "answers devices" do
    device

    get routes.path(:api_devices),
        {},
        "HTTP_AUTHORIZATION" => access_token,
        "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: [
        hash_including(
          id: device.id,
          model_id: model.id,
          playlist_id: playlist.id,
          friendly_id: "ABC123",
          label: "Test",
          mac_address: "A1:B2:C3:D4:E5:F6",
          api_key: "abc123",
          firmware_version: "1.2.3",
          firmware_beta: false,
          wifi: -44,
          battery: 3.0,
          refresh_rate: 900,
          image_timeout: 0,
          width: 0,
          height: 0,
          proxy: false,
          firmware_update: false,
          sleep_start_at: nil,
          sleep_stop_at: nil,
          created_at: match_rfc_3339,
          updated_at: match_rfc_3339
        )
      ]
    )
  end

  it "answers empty array when devices don't exist" do
    get routes.path(:api_devices),
        {},
        "HTTP_AUTHORIZATION" => access_token,
        "CONTENT_TYPE" => "application/json"

    expect(json_payload).to eq(data: [])
  end

  it "answers device when it exists" do
    get routes.path(:api_device, id: device.id),
        {},
        "HTTP_AUTHORIZATION" => access_token,
        "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: {
        id: device.id,
        model_id: model.id,
        playlist_id: playlist.id,
        friendly_id: "ABC123",
        label: "Test",
        mac_address: "A1:B2:C3:D4:E5:F6",
        api_key: "abc123",
        firmware_version: "1.2.3",
        firmware_beta: false,
        wifi: -44,
        battery: 3.0,
        refresh_rate: 900,
        image_timeout: 0,
        width: 0,
        height: 0,
        proxy: false,
        firmware_update: false,
        sleep_start_at: nil,
        sleep_stop_at: nil,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  it "answers not found error when device doesn't exist" do
    get routes.path(:api_device, id: 666),
        {},
        "HTTP_AUTHORIZATION" => access_token,
        "CONTENT_TYPE" => "application/json"

    expect(json_payload).to eq(Petail[status: :not_found].to_h)
  end

  it "creates device with valid attributes" do
    post routes.path(:api_devices),
         {device: attributes}.to_json,
         "HTTP_AUTHORIZATION" => access_token,
         "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: hash_including(
        id: kind_of(Integer),
        model_id: model.id,
        playlist_id: kind_of(Integer),
        friendly_id: match_device_friendly_id,
        label: "Request Test",
        mac_address: "A1:B2:C3:D4:E5:F6",
        api_key: kind_of(String),
        firmware_version: nil,
        firmware_beta: false,
        wifi: 0,
        battery: 0.0,
        refresh_rate: 500,
        image_timeout: 5,
        width: 0,
        height: 0,
        proxy: true,
        firmware_update: true,
        sleep_start_at: "05:00:00",
        sleep_stop_at: "10:00:00",
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      )
    )
  end

  it "creates device with valid (required only) attributes" do
    attributes = {
      model_id: model.id,
      playlist_id: nil,
      label: "Test",
      mac_address: "A1:B2:C3:D4:E5:F6"
    }

    post routes.path(:api_devices),
         {device: attributes}.to_json,
         "HTTP_AUTHORIZATION" => access_token,
         "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: hash_including(
        id: kind_of(Integer),
        model_id: model.id,
        playlist_id: kind_of(Integer),
        friendly_id: match_device_friendly_id,
        label: "Test",
        mac_address: "A1:B2:C3:D4:E5:F6",
        api_key: kind_of(String),
        firmware_version: nil,
        firmware_beta: false,
        wifi: 0,
        battery: 0.0,
        refresh_rate: 900,
        image_timeout: 0,
        width: 0,
        height: 0,
        proxy: false,
        firmware_update: false,
        sleep_start_at: nil,
        sleep_stop_at: nil,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      )
    )
  end

  it "answers problem details when creation fails" do
    attributes.delete :model_id

    post routes.path(:api_devices),
         {device: attributes}.to_json,
         "HTTP_AUTHORIZATION" => access_token,
         "CONTENT_TYPE" => "application/json"

    problem = Petail[
      type: "/problem_details#device_payload",
      status: :unprocessable_entity,
      detail: "Validation failed.",
      instance: "/api/devices",
      extensions: {
        errors: {
          device: {
            model_id: ["is missing"]
          }
        }
      }
    ]

    expect(json_payload).to match(problem.to_h)
  end

  it "answers problem details for invalid model" do
    attributes[:model_id] = 666

    post routes.path(:api_devices),
         {device: attributes}.to_json,
         "HTTP_AUTHORIZATION" => access_token,
         "CONTENT_TYPE" => "application/json"

    problem = Petail[
      type: "/problem_details#device_payload",
      status: :not_found,
      detail: %(Key (model_id)=(666) is not present in table "model".),
      instance: "/api/devices"
    ]

    expect(json_payload).to match(problem.to_h)
  end

  it "patches device when valid" do
    patch routes.path(:api_device_patch, id: device.id),
          {device: {label: "Test Patch"}}.to_json,
          "HTTP_AUTHORIZATION" => access_token,
          "CONTENT_TYPE" => "application/json"

    expect(json_payload.dig(:data, :label)).to eq("Test Patch")
  end

  it "answers original record when there is nothing to patch" do
    patch routes.path(:api_device_patch, id: device.id),
          {device: {}}.to_json,
          "HTTP_AUTHORIZATION" => access_token,
          "CONTENT_TYPE" => "application/json"

    problem = Petail[
      type: "/problem_details#device_payload",
      status: :unprocessable_entity,
      detail: "Validation failed.",
      instance: "/api/devices",
      extensions: {
        errors: {
          device: ["must be filled"]
        }
      }
    ]

    expect(json_payload).to match(problem.to_h)
  end

  it "answers error when patch fails" do
    patch routes.path(:api_device_patch, id: device.id),
          {device: {sleep_stop_at: "10:10:10"}}.to_json,
          "HTTP_AUTHORIZATION" => access_token,
          "CONTENT_TYPE" => "application/json"

    problem = Petail[
      type: "/problem_details#device_payload",
      status: :unprocessable_entity,
      detail: "Validation failed.",
      instance: "/api/devices",
      extensions: {
        errors: {
          device: {
            sleep_start_at: ["must be filled"],
            sleep_stop_at: ["must have corresponding start time"]
          }
        }
      }
    ]

    expect(json_payload).to match(problem.to_h)
  end

  it "deletes existing record" do
    delete routes.path(:api_device_delete, id: device.id),
           {},
           "HTTP_AUTHORIZATION" => access_token,
           "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: {
        id: device.id,
        model_id: model.id,
        playlist_id: playlist.id,
        friendly_id: "ABC123",
        label: "Test",
        mac_address: "A1:B2:C3:D4:E5:F6",
        api_key: "abc123",
        firmware_version: "1.2.3",
        firmware_beta: false,
        wifi: -44,
        battery: 3.0,
        refresh_rate: 900,
        image_timeout: 0,
        width: 0,
        height: 0,
        proxy: false,
        firmware_update: false,
        sleep_start_at: nil,
        sleep_stop_at: nil,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  it "answers empty payload with invalid ID" do
    delete routes.path(:api_device_delete, id: 666),
           {},
           "HTTP_AUTHORIZATION" => access_token,
           "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(data: {})
  end
end
