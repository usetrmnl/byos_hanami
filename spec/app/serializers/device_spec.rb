# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Serializers::Device do
  subject(:serializer) { described_class.new device }

  let :device do
    Factory.structs[:device, model_id: model.id, playlist_id: playlist.id, **attributes]
  end

  let(:model) { Factory.structs[:model] }
  let(:playlist) { Factory.structs[:playlist] }

  let :attributes do
    {
      model_id: model.id,
      playlist_id: playlist.id,
      friendly_id: "ABC123",
      label: "Serialize Test",
      mac_address: "A1:B2:C3:D4:E5:F6",
      api_key: "abc123",
      firmware_version: "1.2.3",
      firmware_beta: false,
      wifi: -40,
      battery: 3.0,
      refresh_rate: 500,
      image_timeout: 5,
      width: 800,
      height: 480,
      proxy: true,
      firmware_update: true,
      sleep_start_at: "05:00:00",
      sleep_stop_at: "10:00:00",
      created_at: "2025-01-01T10:10:10+0000",
      updated_at: "2025-01-01T10:10:10+0000"
    }
  end

  describe "#to_h" do
    it "answers hash" do
      expect(serializer.to_h).to eq(id: device.id, **attributes)
    end
  end
end
