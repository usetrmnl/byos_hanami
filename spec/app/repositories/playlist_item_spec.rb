# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Repositories::PlaylistItem, :db do
  subject(:repository) { described_class.new }

  let(:playlist_item) { Factory[:playlist_item] }

  describe "#all" do
    it "answers all records by created date/time" do
      playlist_item
      two = Factory[:playlist_item]

      expect(repository.all).to eq([playlist_item, two])
    end

    it "answers empty array when records don't exist" do
      expect(repository.all).to eq([])
    end
  end

  describe "#all_by" do
    it "answers record for single attribute" do
      result = repository.all_by playlist_id: playlist_item.playlist_id
      expect(result).to contain_exactly(playlist_item)
    end

    it "answers record for multiple attributes" do
      result = repository.all_by playlist_id: playlist_item.playlist_id,
                                 screen_id: playlist_item.screen_id

      expect(result).to contain_exactly(playlist_item)
    end

    it "answers empty array for unknown value" do
      expect(repository.all_by(playlist_id: 666)).to eq([])
    end

    it "answers empty array for nil" do
      expect(repository.all_by(playlist_id: nil)).to eq([])
    end
  end

  describe "#find" do
    it "answers record by ID" do
      expect(repository.find(playlist_item.id)).to eq(playlist_item)
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
      expect(repository.find_by(playlist_id: playlist_item.playlist_id)).to eq(playlist_item)
    end

    it "answers record when found by multiple attributes" do
      result = repository.find_by playlist_id: playlist_item.playlist_id,
                                  screen_id: playlist_item.screen_id

      expect(result).to eq(playlist_item)
    end

    it "answers nil when not found" do
      expect(repository.find_by(playlist_id: 666)).to be(nil)
    end

    it "answers nil for nil" do
      expect(repository.find_by(playlist_id: nil)).to be(nil)
    end
  end
end
