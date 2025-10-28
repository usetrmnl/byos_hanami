# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Parsers::JSON do
  subject(:parser) { described_class }

  describe "#call" do
    it "answers suceess when body is nil" do
      expect(parser.call(nil)).to be_success("data" => [])
    end

    it "answers success when body is blank" do
      expect(parser.call("")).to be_success({"data" => []})
    end

    it "answers success when body is a hash" do
      body = {test: "example"}.to_json
      expect(parser.call(body)).to be_success("test" => "example")
    end

    it "answers success when body is an array" do
      body = [1, 2, 3].to_json
      expect(parser.call(body)).to be_success("data" => [1, 2, 3])
    end

    it "answers failure with invalid encoding" do
      body = "test\xFF".dup.force_encoding "UTF-8"
      expect(parser.call(body)).to be_failure("Unexpected token 'test' at line 1 column 1.")
    end
  end
end
