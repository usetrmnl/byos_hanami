# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::MapToI do
  subject(:filter) { described_class }

  describe "#call" do
    it "answers characters as zeros" do
      expect(filter.call(%w[a b c])).to eq([0, 0, 0])
    end

    it "answers numbers as numbers" do
      expect(filter.call([1, 2, 3])).to eq([1, 2, 3])
    end
  end
end
