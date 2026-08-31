# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::ToJSON do
  subject(:filter) { described_class }

  describe "#call" do
    it "answers JSON" do
      expect(filter.call([{a: 1}, :b])).to eq(%([{"a":1},"b"]))
    end
  end
end
