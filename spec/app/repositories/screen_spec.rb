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

  describe "#find_by_name" do
    it "answers record when found" do
      expect(repository.find_by_name(screen.name)).to eq(screen)
    end

    it "answers nil when not found" do
      expect(repository.find_by_name("bogus")).to be(nil)
    end

    it "answers nil for nil" do
      expect(repository.find_by_name(nil)).to be(nil)
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

  describe "#upsert_by_name" do
    it "updates existing record" do
      screen
      update = repository.upsert_by_name screen.name, label: "Upsert"

      expect(update).to have_attributes(label: "Upsert")
    end

    it "creates new record when record doesn't exist" do
      model = Factory[:model]
      creation = repository.upsert_by_name "upsert", model_id: model.id, label: "Upsert"

      expect(creation).to have_attributes(name: "upsert", label: "Upsert")
    end

    it "creates and updates records" do
      screen = Factory[:screen, name: "old"]

      repository.upsert_by_name screen.name, label: "Update"
      repository.upsert_by_name "new", model_id: screen.model_id, label: "Create"

      tuples = repository.all.map { [it.name, it.label] }

      expect(tuples).to contain_exactly(%w[old Update], %w[new Create])
    end
  end
end
