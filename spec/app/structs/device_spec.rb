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
  end
end
