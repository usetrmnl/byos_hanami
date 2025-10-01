# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Repositories::UserStatus, :db do
  subject(:repository) { described_class.new }

  include_context "with user statuses"

  describe "#all" do
    it "answers predefined records" do
      expect(repository.all.size).to eq(3)
    end
  end

  describe "#find" do
    it "answers record by ID" do
      expect(repository.find(1)).to have_attributes(id: 1, name: "Unverified")
    end

    it "answers nil for unknown ID" do
      expect(repository.find(666)).to be(nil)
    end

    it "answers nil for nil ID" do
      expect(repository.find(nil)).to be(nil)
    end
  end

  describe "#find_by" do
    let(:proof) { {id: 1, name: "Unverified"} }

    it "answers record when found by single attribute" do
      expect(repository.find_by(id: 1)).to have_attributes(proof)
    end

    it "answers record when found by multiple attributes" do
      expect(repository.find_by(id: 1, name: "Unverified")).to have_attributes(proof)
    end

    it "answers nil when not found" do
      expect(repository.find_by(name: "bogus")).to be(nil)
    end

    it "answers nil for nil" do
      expect(repository.find_by(name: nil)).to be(nil)
    end
  end
end
