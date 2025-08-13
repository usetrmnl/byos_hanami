# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Repositories::Model, :db do
  subject(:repository) { described_class.new }

  let(:model) { Factory[:model] }

  describe "#all" do
    it "answers all records by published date/time" do
      model
      two = Factory[:model, name: "two"]

      expect(repository.all).to eq([model, two])
    end

    it "answers empty array when records don't exist" do
      expect(repository.all).to eq([])
    end
  end

  describe "#find" do
    it "answers record by ID" do
      expect(repository.find(model.id)).to eq(model)
    end

    it "answers nil for unknown ID" do
      expect(repository.find(13)).to be(nil)
    end

    it "answers nil for nil ID" do
      expect(repository.find(nil)).to be(nil)
    end
  end

  describe "#find_by" do
    it "answers record when found by single attribute" do
      expect(repository.find_by(name: model.name)).to eq(model)
    end

    it "answers record when found by multiple attributes" do
      model
      expect(repository.find_by(width: 800, height: 480)).to eq(model)
    end

    it "answers nil when not found" do
      expect(repository.find_by(name: "bogus")).to be(nil)
    end

    it "answers nil for nil" do
      expect(repository.find_by(name: nil)).to be(nil)
    end
  end

  describe "#find_or_create" do
    it "answers existing record" do
      model
      record = repository.find_or_create :name, model.name, label: "Upsert"

      expect(record).to eq(model)
    end

    it "creates new record when record doesn't exist" do
      creation = repository.find_or_create :name, "test", label: "Upsert", width: 1, height: 1
      expect(creation).to have_attributes(name: "test", label: "Upsert", width: 1, height: 1)
    end
  end

  describe "#find_by_dimensions" do
    let(:model) { Factory[:model, name: "og_png", width: 800, height: 480] }

    before { model }

    it "answers record when found by known width" do
      expect(repository.find_by_dimensions(width: 800, height: 480)).to eq(model)
    end

    it "answers nil when width doesn't match" do
      expect(repository.find_by_dimensions(width: 13, height: 480)).to be(nil)
    end

    it "answers nil when height doesn't match" do
      expect(repository.find_by_dimensions(width: 800, height: 13)).to be(nil)
    end
  end

  describe "#search" do
    let(:model) { Factory[:model, label: "Test"] }

    before { model }

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
end
