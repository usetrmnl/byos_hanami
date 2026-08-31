# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::DaysAgo do
  subject(:filter) { described_class }

  describe "#call" do
    it "answers days for default timezone" do
      expect(filter.call(3)).to eq(Date.today - 3)
    end

    it "answers days for custom timezone" do
      expect(filter.call(10, "Europe/London")).to eq(Date.today - 9)
    end
  end
end
