# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Contracts::Devices::Update do
  subject(:contract) { described_class.new }

  describe "#call" do
    let :attributes do
      {
        id: 1,
        device: {
          label: "Test",
          friendly_id: "ABC123",
          mac_address: "AA:BB:CC:11:22:33",
          api_key: "secret",
          refresh_rate: 100,
          image_timeout: 0,
          proxy: "on",
          firmware_update: "on",
          sleep_start_at: Time.new(2025, 1, 1, 1, 1, 1),
          sleep_end_at: Time.new(2025, 2, 1, 1, 1, 1)
        }
      }
    end

    it "answers success when valid" do
      expect(contract.call(attributes)).to be_success
    end

    it "answers success when start and end date/time are nil" do
      attributes[:device].delete :sleep_start_at
      attributes[:device].delete :sleep_end_at

      expect(contract.call(attributes)).to be_success
    end

    it "answers failures when start is after end" do
      attributes[:device][:sleep_start_at] = Time.new 2025, 3, 1, 1, 1, 1

      expect(contract.call(attributes).errors.to_h).to eq(
        device: {
          sleep_start_at: ["must be before end time"],
          sleep_end_at: ["must be after start time"]
        }
      )
    end

    it "answers failures when start is missing but end is present" do
      attributes[:device][:sleep_start_at] = nil

      expect(contract.call(attributes).errors.to_h).to eq(
        device: {
          sleep_start_at: ["must be filled"],
          sleep_end_at: ["must have corresponding start time"]
        }
      )
    end

    it "answers failures when start is present but end is missing" do
      attributes[:device][:sleep_end_at] = nil

      expect(contract.call(attributes).errors.to_h).to eq(
        device: {
          sleep_start_at: ["must have corresponding end time"],
          sleep_end_at: ["must be filled"]
        }
      )
    end
  end
end
