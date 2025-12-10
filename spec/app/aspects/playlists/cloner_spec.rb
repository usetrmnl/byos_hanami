# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Playlists::Cloner, :db do
  subject(:cloner) { described_class.new }

  describe "#call" do
    let(:repository) { Terminus::Repositories::Playlist.new }
    let(:playlist) { Factory[:playlist, label: "Test", name: "test"] }
    let(:item_one) { Factory[:playlist_item, playlist_id: playlist.id, position: 2] }
    let(:item_two) { Factory[:playlist_item, playlist_id: playlist.id, position: 8] }

    before do
      item_one
      repository.update playlist.id, current_item_id: item_two.id
    end

    it "clones playlist" do
      clone = cloner.call(playlist.id).value!
      expect(clone).to have_attributes(label: "Test Clone", name: "test_clone")
    end

    it "clones items" do
      clone = cloner.call(playlist.id).bind { repository.with_items.by_pk(it.id).one }
      attributes = clone.playlist_items.map { {screen_id: it.screen_id, position: it.position} }

      expect(attributes).to eq(
        [
          {screen_id: item_one.screen_id, position: 1},
          {screen_id: item_two.screen_id, position: 2}
        ]
      )
    end

    it "clones current item" do
      clone = cloner.call(playlist.id).bind { repository.with_items.by_pk(it.id).one }
      expect(clone.current_item_id).to eq(item_two.id)
    end

    it "doesn't clone current item when current item doesn't exist" do
      repository.update playlist.id, current_item_id: nil
      clone = cloner.call(playlist.id).bind { repository.with_items.by_pk(it.id).one }

      expect(clone.current_item).to be(nil)
    end

    it "fails when label isn't unique" do
      clone = cloner.call playlist.id, label: playlist.label
      expect(clone).to be_failure(label: ["must be unique"])
    end

    it "fails when name isn't unique" do
      clone = cloner.call playlist.id, name: playlist.name
      expect(clone).to be_failure(name: ["must be unique"])
    end
  end
end
