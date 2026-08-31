# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::AppendRandom do
  subject(:filter) { described_class }

  describe "#call" do
    it "answers value with random number appended" do
      expect(filter.call("test")).to match(/test\h{2}/)
    end

    it "answers value with custom delimiter and random number appended" do
      expect(filter.call("test", "-")).to match(/test-\h{2}/)
    end
  end
end
