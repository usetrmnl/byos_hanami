# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::FindBy do
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

    it "answers item for key and value" do
      expect(filter.call(collection, "name", "Jill")).to eq("name" => "Jill", "age" => 35)
    end

    it "answers nil for unknown key" do
      expect(filter.call(collection, "bogus", "Jill")).to be(nil)
    end

    it "answers nil for unknown value" do
      expect(filter.call(collection, "name", "Bogus")).to be(nil)
    end
  end
end
