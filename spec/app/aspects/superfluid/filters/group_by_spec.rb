# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::GroupBy do
  subject(:filter) { described_class }

  describe "#call" do
    let :collection do
      [
        {
          "name" => "Jill",
          "age" => 35
        },
        {
          "name" => "Sarah",
          "age" => 29
        },
        {
          "name" => "Rayne",
          "age" => 29
        }
      ]
    end

    it "answers hash by group" do
      expect(filter.call(collection, "age")).to eq(
        35 => [{"name" => "Jill", "age" => 35}],
        29 => [{"name" => "Sarah", "age" => 29}, {"name" => "Rayne", "age" => 29}]
      )
    end

    it "answers hash grouped by nil when key is unknown" do
      expect(filter.call(collection, "bogus")).to eq(
        nil => [
          {"name" => "Jill", "age" => 35},
          {"name" => "Sarah", "age" => 29},
          {"name" => "Rayne", "age" => 29}
        ]
      )
    end
  end
end
