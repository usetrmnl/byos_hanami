# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::Sample do
  subject(:filter) { described_class }

  describe "#call" do
    it "answers random value" do
      expect(filter.call(%w[one two three]).to_s).to match(/\A(one|two|three)\Z/)
    end
  end
end
