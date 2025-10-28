# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Parsers::Text do
  subject(:parser) { described_class }

  describe "#call" do
    it "answers suceess when body is nil" do
      expect(parser.call(nil)).to be_success("data" => [])
    end

    it "answers success when body is blank" do
      expect(parser.call("")).to be_success({"data" => []})
    end

    it "answers success with single line" do
      expect(parser.call("test")).to be_success("data" => ["test"])
    end

    it "answers success with multiple lines" do
      expect(parser.call("one\ntwo\nthree")).to be_success("data" => %w[one two three])
    end

    it "answers failure with invalid encoding" do
      body = "test\xFF".dup.force_encoding "UTF-8"
      expect(parser.call(body)).to be_failure("Invalid byte sequence in utf-8.")
    end
  end
end
