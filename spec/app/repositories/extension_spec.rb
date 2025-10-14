# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Repositories::Extension, :db do
  subject(:repository) { described_class.new }

  let(:extension) { Factory[:extension] }

  describe "#all" do
    it "answers all records by published date/time" do
      extension
      two = Factory[:extension, name: "two"]

      expect(repository.all).to eq([extension, two])
    end

    it "answers empty array when records don't exist" do
      expect(repository.all).to eq([])
    end
  end

  describe "#find" do
    it "answers record by ID" do
      expect(repository.find(extension.id)).to eq(extension)
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
      expect(repository.find_by(name: extension.name)).to eq(extension)
    end

    it "answers record when found by multiple attributes" do
      extension
      expect(repository.find_by(name: extension.name, label: extension.label)).to eq(extension)
    end

    it "answers nil when not found" do
      expect(repository.find_by(name: "bogus")).to be(nil)
    end

    it "answers nil for nil" do
      expect(repository.find_by(name: nil)).to be(nil)
    end
  end

  describe "#search" do
    let(:extension) { Factory[:extension, label: "Test"] }

    before { extension }

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

  describe "#where" do
    it "answers record for single attribute" do
      expect(repository.where(label: extension.label)).to contain_exactly(extension)
    end

    it "answers record for multiple attributes" do
      records = repository.where label: extension.label, name: extension.name
      expect(records).to contain_exactly(extension)
    end

    it "answers empty array for unknown value" do
      expect(repository.where(label: "bogus")).to eq([])
    end

    it "answers empty array for nil" do
      expect(repository.where(label: nil)).to eq([])
    end
  end
end
