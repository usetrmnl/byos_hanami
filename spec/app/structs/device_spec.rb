# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Device, :db do
  subject(:device) { Factory[:device, image_timeout: 10, refresh_rate: 20] }

  describe "#display_attributes" do
    it "answers display specific attributes" do
      expect(device.display_attributes).to eq(image_url_timeout: 10, refresh_rate: 20)
    end
  end
end
