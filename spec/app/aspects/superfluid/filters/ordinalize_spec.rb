# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::Ordinalize do
  subject(:filter) { described_class.new }

  describe ".suffix" do
    it "answers st with one" do
      expect(described_class.suffix(1)).to eq("st")
    end

    it "answers nd with two" do
      expect(described_class.suffix(2)).to eq("nd")
    end

    it "answers rd with three" do
      expect(described_class.suffix(3)).to eq("rd")
    end

    it "answers th with four or higher" do
      expect(described_class.suffix(4)).to eq("th")
    end
  end

  describe "#call" do
    it "answers first" do
      expect(filter.call("2000-01-01", "<<ordinal_day>>")).to eq("1st")
    end

    it "answers second" do
      expect(filter.call("2000-01-02", "<<ordinal_day>>")).to eq("2nd")
    end

    it "answers third" do
      expect(filter.call("2000-01-03", "<<ordinal_day>>")).to eq("3rd")
    end

    it "answers twelfth" do
      expect(filter.call("2000-01-12", "<<ordinal_day>>")).to eq("12th")
    end

    it "answers now as date/time" do
      expect(filter.call("now", "%B <<ordinal_day>>")).to match(/[a-zA-Z]+ \d+[a-z]{2}/)
    end

    it "answers today as date/time" do
      expect(filter.call("today", "%B <<ordinal_day>>")).to match(/[a-zA-Z]+ \d+[a-z]{2}/)
    end

    it "answers UNIX timestamp as date/time" do
      expect(filter.call("1788212912", "%A, %B <<ordinal_day>>")).to eq("Monday, August 31st")
    end

    it "answers day (long), month, and day (short)" do
      expect(filter.call("2025-12-31 16:50:38 -0400", "%A, %b <<ordinal_day>>")).to eq(
        "Wednesday, Dec 31st"
      )
    end

    it "answers day (long), month, day (short), and year" do
      expect(filter.call("2025-10-02", "%A, %B <<ordinal_day>>, %Y")).to eq(
        "Thursday, October 2nd, 2025"
      )
    end
  end
end
