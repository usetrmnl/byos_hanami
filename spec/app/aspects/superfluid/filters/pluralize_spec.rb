# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::Pluralize do
  subject(:filter) { described_class }

  describe "#call" do
    it "answers plural when count is zero" do
      expect(filter.call("book")).to eq("0 books")
    end

    it "answers singular when count is one" do
      expect(filter.call("book", 1)).to eq("1 book")
    end

    it "answers plural when count is more than one" do
      expect(filter.call("book", 2)).to eq("2 books")
    end

    it "answers plural for complex word" do
      expect(filter.call("octopus", 3, "i", "us")).to eq("3 octopi")
    end

    it "answers singular for complex word" do
      expect(filter.call("person", 3, "ople", "rson")).to eq("3 people")
    end

    it "answers plural for alternate pluralization" do
      expect(filter.call("person", 3, "humans", "person")).to eq("3 humans")
    end
  end
end
