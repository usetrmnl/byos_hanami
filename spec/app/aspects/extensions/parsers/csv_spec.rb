# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Parsers::CSV do
  subject(:parser) { described_class }

  describe "#call" do
    it "answers success when body is nil" do
      expect(parser.call(nil)).to be_success("data" => [])
    end

    it "answers success when body is blank" do
      expect(parser.call("")).to be_success("data" => [])
    end

    it "answers success when body has no headers or rows" do
      expect(parser.call("bogus")).to be_success("data" => [])
    end

    it "answers success with valid headers and rows" do
      body = <<~BODY
        title,director
        Castle in the Sky,Hayao Miyazaki
      BODY

      expect(parser.call(body)).to be_success(
        "data" => [{"director" => "Hayao Miyazaki", "title" => "Castle in the Sky"}]
      )
    end

    it "answers failure with invalid encoding" do
      body = "name,city\nJohn,New\xFFYork".dup.force_encoding "UTF-8"
      expect(parser.call(body)).to be_failure("Invalid byte sequence in UTF-8 in line 2.")
    end

    it "answers failure with missing quote" do
      body = <<~BODY
        title,director
        "Castle in the Sky,Hayao Miyazaki
      BODY

      expect(parser.call(body)).to be_failure("Unclosed quoted field in line 2.")
    end
  end
end
