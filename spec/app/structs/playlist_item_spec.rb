# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::PlaylistItem do
  subject :playlist_item do
    Factory.structs[
      :playlist_item,
      screen_id: 1,
      position: 1,
      repeat_interval: 1,
      repeat_type: "none",
      repeat_days: {},
      last_day_of_month: true,
      start_at: at,
      stop_at: at,
      hidden_at: at
    ]
  end

  let(:at) { Time.new 2025, 1, 1 }

  describe "#cloneable_attributes" do
    it "answers included attributes only" do
      expect(playlist_item.cloneable_attributes).to eq(
        screen_id: 1,
        position: 1,
        repeat_interval: 1,
        repeat_type: "none",
        repeat_days: {},
        last_day_of_month: true,
        start_at: at,
        stop_at: at,
        hidden_at: at
      )
    end
  end
end
