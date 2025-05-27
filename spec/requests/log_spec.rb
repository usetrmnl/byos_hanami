# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "/api/log", :db do
  let(:device) { Factory[:device] }
  let(:repository) { Hanami.app["repositories.device_log"] }

  let :headers do
    {
      "CONTENT_TYPE" => "application/json",
      "HTTP_BASE64" => "true",
      "HTTP_FW_VERSION" => "0.0.0",
      "HTTP_ACCESS_TOKEN" => "abc123",
      "HTTP_HEIGHT" => 480,
      "HTTP_HOST" => "test.io",
      "HTTP_ID" => device.mac_address,
      "HTTP_REFRESH_RATE" => 100,
      "HTTP_USER_AGENT" => "test",
      "HTTP_WIDTH" => 800
    }
  end

  let :payload do
    {
      log: {
        logs_array: [
          {
            device_status_stamp: {
              battery_voltage: 4.772,
              current_fw_version: "1.2.3",
              free_heap_size: 160656,
              max_alloc_size: 990000,
              refresh_rate: 30,
              special_function: "none",
              time_since_last_sleep_start: 31,
              wakeup_reason: "timer",
              wifi_rssi_level: -54,
              wifi_status: "connected"
            },
            additional_info: {
              retry_attempt: 1
            },
            log_codeline: 597,
            log_id: 2,
            log_message: "Danger!",
            log_sourcefile: "src/bl.cpp",
            creation_timestamp: 1742000523
          }
        ]
      }
    }
  end

  context "with valid payload" do
    before { post routes.path(:api_log_create), payload.to_json, **headers }

    it "create record" do
      expect(repository.all.first).to have_attributes(
        device_id: device.id,
        external_id: 2,
        message: "Danger!",
        special_function: "none",
        retry: 1,
        created_at: Time.utc(2025, 3, 15, 1, 2, 3)
      )
    end

    it "answers success (no content)" do
      expect(last_response.status).to eq(204)
    end
  end

  context "with invalid payload" do
    before { post routes.path(:api_log_create), {log: {log_array: []}}.to_json, **headers }

    it "doesn't create record" do
      expect(repository.all).to eq([])
    end

    it "answers problem details" do
      problem = Petail.new(
        status: :unprocessable_entity,
        detail: "Validation failed.",
        instance: "/api/log",
        extensions: {log: {logs_array: ["is missing"]}}
      )

      expect(json_payload).to eq(problem.to_h)
    end

    it "answers content type and status" do
      expect(last_response).to have_attributes(
        content_type: "application/problem+json; charset=utf-8",
        status: 422
      )
    end
  end
end
