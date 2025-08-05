# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Relations::Playlist, :db do
  subject(:relation) { Hanami.app["relations.playlist"] }

  describe "#set_current_item" do
    it "updates current item when not set" do
      playlist = Factory[:playlist]
      item = Factory[:playlist_item, playlist_id: playlist.id]
      record = relation.set_current_item playlist.id, item.id

      expect(record.to_h).to include(current_item_id: item.id)
    end

    it "doesn't update current item when not set" do
      playlist = Factory[:playlist]
      item = Factory[:playlist_item]
      record = relation.set_current_item playlist.id, item.id

      expect(record.to_h).to include(current_item_id: nil)
    end
  end
end
