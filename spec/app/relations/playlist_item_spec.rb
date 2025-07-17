# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Relations::PlaylistItem, :db do
  subject(:relation) { Hanami.app["relations.playlist_item"] }

  describe "#next_item" do
    it "answers current item when only item" do
      playlist_id = Factory[:playlist].id
      item = Factory[:playlist_item, playlist_id:, position: 1]

      expect(relation.next_item(playlist_id:, after: item.position)).to include(position: 1)
    end

    it "answers next item when not at last position" do
      playlist_id = Factory[:playlist].id
      Factory[:playlist_item, playlist_id:, position: 1]
      Factory[:playlist_item, playlist_id:, position: 2]

      expect(relation.next_item(after: 1, playlist_id:)).to include(position: 2)
    end

    it "answers first item when at last position" do
      playlist_id = Factory[:playlist].id
      Factory[:playlist_item, playlist_id:, position: 1]
      Factory[:playlist_item, playlist_id:, position: 2]

      expect(relation.next_item(after: 2, playlist_id:)).to include(position: 1)
    end
  end
end
