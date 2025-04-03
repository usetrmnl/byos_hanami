# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Devices::Builder do
  subject(:builder) { described_class.new randomizer:, time: }

  let :randomizer do
    class_double SecureRandom, hex: "abc123", alphanumeric: "Ov2tWq4XoYCH2xPfiZqc"
  end

  let(:time) { class_double Time, now: at }
  let(:at) { Time.new 2025, 1, 2, 3, 4, 5 }

  describe "#call" do
    it "answers defaults" do
      expect(builder.call).to eq(
        label: "TRMNL",
        friendly_id: "ABC123",
        api_key: "Ov2tWq4XoYCH2xPfiZqc",
        refresh_rate: 900,
        image_timeout: 0,
        setup_at: at
      )
    end
  end
end
