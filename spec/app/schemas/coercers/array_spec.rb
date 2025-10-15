# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Schemas::Coercers::Array do
  subject(:coercer) { described_class }

  let(:attributes) { {days: "monday,tuesday,wednesday"} }

  let :result do
    Dry::Schema::Result.new(attributes, message_compiler: proc { Hash.new }, result_ast: [])
  end

  describe "#call" do
    it "answers multiple item array when key and value are present" do
      expect(coercer.call(:days, result)).to eq(days: %w[monday tuesday wednesday])
    end

    it "answers single item array when key is present and value is a string with no delimiter" do
      attributes[:days] = "monday"
      expect(coercer.call(:days, result)).to eq(days: ["monday"])
    end

    it "answers empty array when key is present and value is nil" do
      attributes[:days] = nil
      expect(coercer.call(:days, result)).to eq(days: [])
    end

    it "answers empty array when key is present and value is blank" do
      attributes[:days] = ""
      expect(coercer.call(:days, result)).to eq(days: [])
    end

    it "answers empty hash when key is missing" do
      attributes.clear
      expect(coercer.call(:days, result)).to eq({})
    end
  end
end
