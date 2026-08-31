# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::NumberWithDelimiter do
  subject(:filter) { described_class.new }

  describe "#call" do
    it "answers original value when not a number" do
      expect(filter.call("test")).to eq("test")
    end

    it "answers original value when a mix of characters" do
      expect(filter.call("test12")).to eq("test12")
    end

    it "answers with default comma" do
      expect(filter.call("1234.57")).to eq("1,234.57")
    end

    it "answers with negative" do
      expect(filter.call(-1234)).to eq("-1,234")
    end

    it "answers group with comma" do
      expect(filter.call(1234)).to eq("1,234")
    end

    it "answers group with period" do
      expect(filter.call(1234, ".")).to eq("1.234")
    end

    it "answers space and comma" do
      expect(filter.call("1234.57", " ", ",")).to eq("1 234,57")
    end
  end
end
