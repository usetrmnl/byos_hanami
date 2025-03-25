# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::API::Transformers::FirmwareLog do
  subject(:firmware_log) { described_class.new }

  let :payload do
    {
      log: {
        logs_array: [
          {
            device_status_stamp: {
              wifi_rssi_level: -54,
              wifi_status: "connected",
              refresh_rate: 30,
              time_since_last_sleep_start: 31,
              current_fw_version: "1.4.7",
              special_function: "none",
              battery_voltage: 4.772,
              wakeup_reason: "timer",
              free_heap_size: 160656
            },
            additional_info: {
              retry_attempt: 1
            },
            creation_timestamp: 1742000523,
            log_id: 1,
            log_message: "returned code is not OK: 404",
            log_codeline: 597,
            log_sourcefile: "src/bl.cpp"
          }
        ]
      }
    }
  end

  describe "#call" do
    it "answers transformed attributes" do
      expect(firmware_log.call(payload)).to eq(
        [
          {
            battery_voltage: 4.772,
            created_at: Time.utc(2025, 3, 15, 1, 2, 3),
            external_id: 1,
            firmware_version: "1.4.7",
            free_heap_size: 160656,
            message: "returned code is not OK: 404",
            refresh_rate: 30,
            retry: 1,
            sleep_duration: 31,
            source_line: 597,
            source_path: "src/bl.cpp",
            special_function: "none",
            wake_reason: "timer",
            wifi_signal: -54,
            wifi_status: "connected"
          }
        ]
      )
    end

    it "answers empty array when log key is missing" do
      expect(firmware_log.call({})).to eq([])
    end

    it "answers empty array when logs array key is missing" do
      expect(firmware_log.call({log: {}})).to eq([])
    end
  end
end
