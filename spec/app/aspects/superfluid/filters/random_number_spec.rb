# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::RandomNumber do
  subject(:filter) { described_class }

  describe "#call" do
    let(:randomizer) { class_double SecureRandom }
    let(:pattern) { /\A(1|2|3|4|5|6)\Z/ }

    it "answers number with default bounds" do
      allow(randomizer).to receive(:random_number).with(101).and_return(100)
      expect(filter.call("", randomizer:)).to eq(100)
    end

    it "answers number when bounds are strings" do
      expect(filter.call("", "1", "6").to_s).to match(pattern)
    end

    it "answers number and ignores value" do
      expect(filter.call(10, 1, 6).to_s).to match(pattern)
    end

    it "answers number within bounds" do
      expect(filter.call("", 1, 6).to_s).to match(pattern)
    end

    it "answers number with reversed bounds" do
      expect(filter.call("", 6, 1).to_s).to match(pattern)
    end

    it "uses single bound as maximum" do
      allow(randomizer).to receive(:random_number).with(7).and_return(6)
      expect(filter.call("", 6, randomizer:)).to eq(6)
    end

    it "uses both bounds" do
      allow(randomizer).to receive(:random_number).with(6).and_return(5)
      expect(filter.call("", 1, 6, randomizer:)).to eq(6)
    end

    it "answers minimum with equal bounds" do
      expect(filter.call("", 3, 3)).to eq(3)
    end
  end
end
