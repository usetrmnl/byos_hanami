# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Errors::Detailer do
  subject(:detailer) { described_class.new }

  describe "#call" do
    let :schema do
      Dry::Schema.Params do
        required(:name).filled :string
        required(:age).filled :integer
      end
    end

    it "answers string for result with single error" do
      result = schema.call({name: "Test"})
      expect(detailer.call(result)).to eq("age is missing.")
    end

    it "answers string for result with multiple errors" do
      result = schema.call({})
      expect(detailer.call(result)).to eq("name is missing and age is missing.")
    end

    it "answers string for result with prefix" do
      result = schema.call({name: "Test"})
      expect(detailer.call(result, "Test ")).to eq("Test age is missing.")
    end

    it "answers string for hash with multiple errors per key" do
      result = {name: ["is missing"], age: ["must be an integer", "must be positive"]}

      expect(detailer.call(result)).to eq(
        "name is missing and age must be an integer and must be positive."
      )
    end

    it "answers string for nested hash" do
      result = {exchanges: {0 => {verb: ["is missing"]}}}
      expect(detailer.call(result)).to eq("exchanges.0.verb is missing.")
    end

    it "answers string for hash and prefix" do
      result = {age: ["is missing"]}
      expect(detailer.call(result, "Test ")).to eq("Test age is missing.")
    end

    it "answers string for string" do
      expect(detailer.call("Danger!")).to eq("Danger!")
    end

    it "answers string for string and prefix" do
      expect(detailer.call("Danger!", "Test ")).to eq("Test Danger!")
    end
  end
end
