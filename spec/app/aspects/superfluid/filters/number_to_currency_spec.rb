# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::NumberToCurrency do
  subject(:filter) { described_class.new }

  describe "#call" do
    it "answers USD" do
      content = filter.call "10420"
      expect(content).to eq("$10,420.00")
    end

    it "answers pounds" do
      content = filter.call "152350.69", "£"
      expect(content).to eq("£152,350.69")
    end

    it "answers pounds with period and comma" do
      content = filter.call "1234.57", "£", ".", ","
      expect(content).to eq("£1.234,57")
    end

    it "answers Krones" do
      pending "Needs locale support"

      content = filter.call "567", "sv"
      expect(content).to eq("567.00 kr")
    end

    it "answers custom format" do
      content = filter.call "123", "tbd"
      expect(content).to eq("tbd123.00")
    end

    it "answers value without decimal when precision is zero or less" do
      content = filter.call "123", "$", ",", ".", 0
      expect(content).to eq("$123")
    end
  end
end
