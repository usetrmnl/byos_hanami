# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Relations::PlaylistItem, :db do
  subject(:relation) { Hanami.app["relations.playlist_item"] }

  describe "#previous" do
    it "answers item with only one item" do
      playlist_id = Factory[:playlist].id
      item = Factory[:playlist_item, playlist_id:, position: 1]

      expect(relation.previous(playlist_id:, position: item.position)).to include(
        position: 1,
        screen: kind_of(Hash)
      )
    end

    it "answers item with gaps after" do
      playlist_id = Factory[:playlist].id
      Factory[:playlist_item, playlist_id:, position: 1]

      expect(relation.previous(playlist_id:, position: 3)).to include(
        position: 1,
        screen: kind_of(Hash)
      )
    end

    it "answers item with gaps before" do
      playlist_id = Factory[:playlist].id
      Factory[:playlist_item, playlist_id:, position: 3]

      expect(relation.previous(playlist_id:, position: 1)).to include(
        position: 3,
        screen: kind_of(Hash)
      )
    end

    it "answers item when not at first position" do
      playlist_id = Factory[:playlist].id
      Factory[:playlist_item, playlist_id:, position: 1]
      Factory[:playlist_item, playlist_id:, position: 2]

      expect(relation.previous(playlist_id:, position: 2)).to include(
        position: 1,
        screen: kind_of(Hash)
      )
    end

    it "answers last item when at first position" do
      playlist_id = Factory[:playlist].id
      Factory[:playlist_item, playlist_id:, position: 1]
      Factory[:playlist_item, playlist_id:, position: 2]

      expect(relation.previous(playlist_id:, position: 1)).to include(
        position: 2,
        screen: kind_of(Hash)
      )
    end
  end

  describe "#subsequent" do
    it "answers item with only one item" do
      playlist_id = Factory[:playlist].id
      item = Factory[:playlist_item, playlist_id:, position: 1]

      expect(relation.subsequent(playlist_id:, position: item.position)).to include(
        position: 1,
        screen: kind_of(Hash)
      )
    end

    it "answers item with gaps before" do
      playlist_id = Factory[:playlist].id
      Factory[:playlist_item, playlist_id:, position: 1]

      expect(relation.subsequent(playlist_id:, position: 3)).to include(
        position: 1,
        screen: kind_of(Hash)
      )
    end

    it "answers item with gaps after" do
      playlist_id = Factory[:playlist].id
      Factory[:playlist_item, playlist_id:, position: 3]

      expect(relation.subsequent(playlist_id:, position: 1)).to include(
        position: 3,
        screen: kind_of(Hash)
      )
    end

    it "answers item when not at last position" do
      playlist_id = Factory[:playlist].id
      Factory[:playlist_item, playlist_id:, position: 1]
      Factory[:playlist_item, playlist_id:, position: 2]

      expect(relation.subsequent(playlist_id:, position: 1)).to include(
        position: 2,
        screen: kind_of(Hash)
      )
    end

    it "answers first item when at last position" do
      playlist_id = Factory[:playlist].id
      Factory[:playlist_item, playlist_id:, position: 1]
      Factory[:playlist_item, playlist_id:, position: 2]

      expect(relation.subsequent(playlist_id:, position: 2)).to include(
        position: 1,
        screen: kind_of(Hash)
      )
    end
  end
end
