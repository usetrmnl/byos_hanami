# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Repositories::Playlist, :db do
  subject(:repository) { described_class.new }

  let(:playlist) { Factory[:playlist] }

  describe "#all" do
    it "answers all records by created date/time" do
      playlist
      two = Factory[:playlist, name: "two"]

      expect(repository.all).to eq([playlist, two])
    end

    it "answers empty array when records don't exist" do
      expect(repository.all).to eq([])
    end
  end

  describe "#find" do
    it "answers record by ID" do
      expect(repository.find(playlist.id)).to have_attributes(playlist.to_h)
    end

    it "answers nil for unknown ID" do
      expect(repository.find(666)).to be(nil)
    end

    it "answers nil for nil ID" do
      expect(repository.find(nil)).to be(nil)
    end
  end

  describe "#find_by" do
    it "answers record when found by single attribute" do
      expect(repository.find_by(name: playlist.name)).to have_attributes(playlist.to_h)
    end

    it "answers record when found by multiple attributes" do
      expect(repository.find_by(name: playlist.name, label: playlist.label)).to have_attributes(
        playlist.to_h
      )
    end

    it "answers nil when not found" do
      expect(repository.find_by(name: "bogus")).to be(nil)
    end

    it "answers nil for nil" do
      expect(repository.find_by(name: nil)).to be(nil)
    end
  end

  describe "#search" do
    let(:playlist) { Factory[:playlist, label: "Test"] }

    before { playlist }

    it "answers records for case insensitive value" do
      expect(repository.search(:label, "test")).to contain_exactly(have_attributes(label: "Test"))
    end

    it "answers records for partial value" do
      expect(repository.search(:label, "te")).to contain_exactly(have_attributes(label: "Test"))
    end

    it "answers empty array for invalid value" do
      expect(repository.search(:label, "bogus")).to eq([])
    end
  end

  describe "#update_current_item" do
    it "updates current item when item exists" do
      playlist = Factory[:playlist]
      item = Factory[:playlist_item]
      update = repository.update_current_item playlist.id, item

      expect(update).to have_attributes(current_item_id: item.id)
    end

    it "doesn't update current item is nil" do
      playlist = Factory[:playlist]
      update = repository.update_current_item playlist.id, nil

      expect(update.current_item_id).to be(nil)
    end
  end

  describe "#where" do
    it "answers record for single attribute" do
      expect(repository.where(label: playlist.label)).to contain_exactly(playlist)
    end

    it "answers record for multiple attributes" do
      expect(repository.where(label: playlist.label, name: playlist.name)).to contain_exactly(
        playlist
      )
    end

    it "answers empty array for unknown value" do
      expect(repository.where(label: "bogus")).to eq([])
    end

    it "answers empty array for nil" do
      expect(repository.where(label: nil)).to eq([])
    end
  end
end
