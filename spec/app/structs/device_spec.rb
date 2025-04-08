# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Device, :db do
  subject(:device) { Factory[:device, image_timeout: 10, refresh_rate: 20] }

  describe "#as_api_display" do
    it "answers display specific attributes" do
      expect(device.as_api_display).to eq(
        image_url_timeout: 10,
        refresh_rate: 20,
        update_firmware: false
      )
    end
  end
end
