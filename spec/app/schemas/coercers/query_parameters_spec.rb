# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Schemas::Coercers::QueryParameters do
  subject(:coercer) { described_class }

  let :attributes do
    {headers: "accept=application/json&content-type=application/json"}
  end

  let :result do
    Dry::Schema::Result.new attributes, message_compiler: proc { "" }, result_ast: []
  end

  describe "#call" do
    it "answers hash key and value are present" do
      expect(coercer.call(:headers, result)).to eq(
        headers: {
          "accept" => "application/json",
          "content-type" => "application/json"
        }
      )
    end

    it "answers nil when key is present and value is nil" do
      attributes[:headers] = nil
      expect(coercer.call(:headers, result)).to eq(headers: nil)
    end

    it "answers nil key is present and value is blank" do
      attributes[:headers] = ""
      expect(coercer.call(:headers, result)).to eq(headers: nil)
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
