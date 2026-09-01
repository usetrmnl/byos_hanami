# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::LocalizeWord do
  subject(:filter) { described_class.new }

  describe "#call" do
    it "answers translation" do
      expect(filter.call("today")).to eq("today")
    end

    it "answers default translation when key is missing" do
      expect(filter.call("today", "xx")).to eq("today")
    end
  end
end
