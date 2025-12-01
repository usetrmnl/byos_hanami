# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Devices::Defaulter do
  subject(:builder) { described_class.new randomizer: }

  let :randomizer do
    class_double SecureRandom, hex: "abc123", alphanumeric: "Ov2tWq4XoYCH2xPfiZqc"
  end

  describe "#call" do
    it "answers defaults" do
      expect(builder.call).to eq(
        api_key: "Ov2tWq4XoYCH2xPfiZqc",
        firmware_update: true,
        friendly_id: "ABC123",
        image_timeout: 0,
        label: "TRMNL",
        refresh_rate: 900
      )
    end
  end
end
