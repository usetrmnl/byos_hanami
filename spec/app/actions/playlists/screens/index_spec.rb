# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Playlists::Screens::Index, :db do
  subject(:action) { described_class.new }

  describe ".load_screens" do
    let(:nascent) { Factory[:playlist] }
    let(:screen) { Factory[:screen, :with_image] }
    let(:item) { Factory[:playlist_item, playlist_id: nascent.id, screen_id: screen.id] }
    let(:playlist) { Terminus::Repositories::Playlist.new.with_screens.by_pk(nascent.id).one }

    it "answers nil when there are no screens" do
      expect(described_class.load_screens(playlist)).to be(nil)
    end

    it "centers on first when there isn't a current item" do
      (1..3).each do |index|
        Factory[
          :playlist_item,
          playlist_id: nascent.id,
          screen_id: Factory[:screen, :with_image, id: index].id,
          position: index
        ]
      end

      screen_ids = described_class.load_screens(playlist).map(&:id)
      expect(screen_ids).to eq([3, 1, 2])
    end

    it "centers on specific screen (last screen) when current item is set" do
      (1..3).each do |index|
        Factory[
          :playlist_item,
          playlist_id: nascent.id,
          screen_id: Factory[:screen, :with_image, id: index].id,
          position: index
        ]
      end

      item = Terminus::Repositories::PlaylistItem.new.all.last
      Terminus::Repositories::Playlist.new.update nascent.id, current_item_id: item.id

      screen_ids = described_class.load_screens(playlist).map(&:id)
      expect(screen_ids).to eq([2, 3, 1])
    end
  end
end
