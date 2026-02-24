# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Capsule do
  subject(:capsule) { described_class.new }

  describe "#initialize" do
    it "answers defaults" do
      expect(capsule).to eq(described_class[content: {}, errors: {}])
    end
  end

  describe "#clear" do
    it "clears all members" do
      capsule = described_class[content: {a: 1}, errors: {"test" => "Danger!"}]
      capsule.clear

      expect(capsule).to eq(described_class.new)
    end
  end

  describe "#errors?" do
    it "answers true when errors exist" do
      capsule.errors["test"] = "Danger!"
      expect(capsule.errors?).to be(true)
    end

    it "answers false when errors don't exist" do
      expect(capsule.errors?).to be(false)
    end
  end
end
