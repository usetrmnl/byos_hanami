# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Playlist, :db do
  subject(:playlist) { Factory[:playlist] }

  describe "#automatic?" do
    it "answers true when automatic" do
      expect(playlist.automatic?).to be(true)
    end

    it "answers false if not automatic" do
      playlist = Factory.structs[:playlist, mode: "manual"]
      expect(playlist.automatic?).to be(false)
    end
  end

  describe "#current_item_position" do
    let(:update) { Terminus::Repositories::Playlist.new.find playlist.id }

    it "answers default when current item is missing" do
      expect(update.current_item_position).to eq(1)
    end

    it "answers position when current item is available" do
      Factory[:playlist, current_item_id: Factory[:playlist_item, position: 5].id]
      expect(update.current_item_position).to eq(1)
    end
  end

  describe "#manual?" do
    it "answers true when manual" do
      playlist = Factory.structs[:playlist, mode: "manual"]
      expect(playlist.manual?).to be(true)
    end

    it "answers false if not manual" do
      expect(playlist.manual?).to be(false)
    end
  end
end
