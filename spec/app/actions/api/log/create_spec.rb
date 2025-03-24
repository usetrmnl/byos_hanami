# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::API::Log::Create, :db do
  subject(:action) { described_class.new logger: }

  let(:logger) { instance_spy Dry::Logger::Dispatcher }

  describe "#call" do
    let :headers do
      {
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

    let(:device) { Factory[:device] }
    let(:repository) { Hanami.app["repositories.device_log"] }

    it "create record" do
      # FIX: Using GET to trick payload processing. Not ideal.
      Rack::MockRequest.new(action).get "", **headers, params: payload

      expect(repository.all.first).to have_attributes(
        device_id: device.id,
        external_id: 2,
        message: "Danger!",
        special_function: "none",
        retry: 1,
        created_at: Time.utc(2025, 3, 15, 1, 2, 3)
      )
    end

    it "logs errors when parameters are invalid" do
      Rack::MockRequest.new(action).post "/api/log", headers
      expect(logger).to have_received(:error).with(log: ["is missing"])
    end

    it "answers success (no content)" do
      response = Rack::MockRequest.new(action).post "/api/log", headers
      expect(response.status).to eq(204)
    end
  end
end
