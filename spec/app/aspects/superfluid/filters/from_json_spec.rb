# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::FromJSON do
  subject(:filter) { described_class }

  describe "#call" do
    it "answers hash" do
      value = [{"a" => 1}, "b"]
      expect(filter.call(value.to_json)).to eq(value)
    end
  end
end
