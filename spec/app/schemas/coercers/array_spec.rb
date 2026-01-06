# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Schemas::Coercers::Array do
  subject(:coercer) { described_class }

  let(:attributes) { {days: "monday\ntuesday\nwednesday"} }

  let :result do
    Dry::Schema::Result.new(attributes, message_compiler: proc { Hash.new }, result_ast: [])
  end

  describe "#call" do
    it "answers multiple item array when split by new line" do
      expect(coercer.call(:days, result)).to eq(days: %w[monday tuesday wednesday])
    end

    it "answers multiple item array when split by carriage return and new lines" do
      attributes[:days] = "monday\r\ntuesday\r\nwednesday"
      expect(coercer.call(:days, result)).to eq(days: %w[monday tuesday wednesday])
    end

    it "answers multiple item array when split by carriage returns" do
      attributes[:days] = "monday\rtuesday\rwednesday"
      expect(coercer.call(:days, result)).to eq(days: %w[monday tuesday wednesday])
    end

    it "answers multiple item array when split by spaces" do
      attributes[:days] = "monday tuesday wednesday"
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

    it "answers empty hash when result has nil value" do
      result = Dry::Schema::Result.new(nil, message_compiler: proc { Hash.new }, result_ast: [])
      expect(coercer.call(:days, result)).to eq({})
    end
  end
end
