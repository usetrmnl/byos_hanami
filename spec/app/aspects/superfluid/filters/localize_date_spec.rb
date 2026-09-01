# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::LocalizeDate do
  subject(:filter) { described_class.new }

  describe "#call" do
    it "answers now as formatted date/time" do
      expect(filter.call("now", "%Y-%m-%d")).to match(/\d{4}-\d{2}-\d{2}/)
    end

    it "answers today as formatted date/time" do
      expect(filter.call("today", "%Y-%m-%d")).to match(/\d{4}-\d{2}-\d{2}/)
    end

    it "answers UNIX timestamp as date/time" do
      expect(filter.call("1788278951", "%Y %b")).to eq("2026 Sep")
    end

    it "answers short year and month" do
      expect(filter.call("2025-09-01", "%y %b")).to eq("25 Sep")
    end

    it "answers time using key" do
      expect(filter.call("2026-09-01T10:15", "shorter")).to eq("10:15 AM")
    end

    it "answers default translation when key is missing" do
      expect(filter.call("2025-09-01", "%y %b", "xx")).to eq("25 Sep")
    end
  end
end
