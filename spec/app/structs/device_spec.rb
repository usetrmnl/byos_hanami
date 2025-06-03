# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Device, :db do
  subject :device do
    Factory[:device, image_timeout: 10, mac_address: "AA:BB:CC:11:22:33", refresh_rate: 20]
  end

  describe "#as_api_display" do
    it "answers display specific attributes" do
      expect(device.as_api_display).to eq(
        image_url_timeout: 10,
        refresh_rate: 20,
        update_firmware: false
      )
    end
  end

  describe "#slug" do
    it "answers string with no colons" do
      expect(device.slug).to eq("AABBCC112233")
    end

    it "answers empty string when slug is nil" do
      device = Factory[:device, mac_address: nil]
      expect(device.slug).to eq("")
    end
  end

  describe "#asleep?" do
    subject :device do
      Factory[
        :device,
        sleep_start_at: Time.new(2025, 1, 1, 1, 1, 0),
        sleep_end_at: Time.new(2025, 1, 1, 1, 10, 0)
      ]
    end

    it "answers true when current time is within period" do
      expect(device.asleep?(Time.new(2025, 1, 1, 1, 5, 0))).to be(true)
    end

    it "answers false when current time is outside period" do
      expect(device.asleep?(Time.new(2025, 1, 1, 1, 20, 0))).to be(false)
    end

    it "answers false when start and end are nil" do
      expect(device.asleep?).to be(false)
    end
  end
end
