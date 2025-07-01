# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Repositories::Screen, :db do
  subject(:repository) { described_class.new }

  let(:screen) { Factory[:screen] }

  describe "#all" do
    it "answers all records" do
      screen
      old = Factory[:screen, updated_at: Time.utc(2025, 1, 1)]

      expect(repository.all).to eq([screen, old])
    end

    it "answers empty array when records don't exist" do
      expect(repository.all).to eq([])
    end
  end

  describe "#delete" do
    it "deletes existing record" do
      screen
      repository.delete screen.id

      expect(repository.all).to eq([])
    end

    it "deletes associated image" do
      upload = screen.upload SPEC_ROOT.join("support/fixtures/test.png").open
      repository.update screen.id, image_data: upload.data
      repository.delete screen.id

      expect(Hanami.app[:shrine].storages[:store].store).to eq({})
    end

    it "ignores unknown record" do
      repository.delete 13
      expect(repository.all).to eq([])
    end
  end

  describe "#find" do
    it "answers record by ID" do
      expect(repository.find(screen.id)).to eq(screen)
    end

    it "answers nil for unknown ID" do
      expect(repository.find(13)).to be(nil)
    end

    it "answers nil for nil ID" do
      expect(repository.find(nil)).to be(nil)
    end
  end

  describe "#find_by" do
    it "answers record when found" do
      expect(repository.find_by(name: screen.name)).to eq(screen)
    end

    it "answers record when found by multiple attributes" do
      expect(repository.find_by(name: screen.name, label: screen.label)).to eq(screen)
    end

    it "answers nil when not found" do
      expect(repository.find_by(name: "bogus")).to be(nil)
    end

    it "answers nil for nil" do
      expect(repository.find_by(name: nil)).to be(nil)
    end
  end

  describe "#latest" do
    it "answers latest record" do
      screen
      Factory[:screen, updated_at: Time.utc(2025, 1, 1)]

      expect(repository.latest).to eq(screen)
    end

    it "answers nil with only sleep records" do
      Factory[:screen, name: "sleep.bmp"]
      Factory[:screen, name: "sleep.png"]

      expect(repository.latest).to be(nil)
    end

    it "answers nil when records don't exist" do
      expect(repository.latest).to be(nil)
    end
  end
end
