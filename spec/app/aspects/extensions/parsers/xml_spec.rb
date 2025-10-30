# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Parsers::XML do
  subject(:parser) { described_class }

  describe "#call" do
    let :body do
      <<~CONTENT
        <catalog>
          <book>
            <title>Book 1</title>
          </book>
          <book>
            <title>Book 2</title>
          </book>
        </catalog>
      CONTENT
    end

    it "answers success when body is nil" do
      expect(parser.call(nil)).to be_success("data" => {})
    end

    it "answers success when body is blank" do
      expect(parser.call("")).to be_success("data" => {})
    end

    it "answers success with valid body" do
      expect(parser.call(body)).to be_success(
        "catalog" => {
          "book" => [
            {"title" => "Book 1"},
            {"title" => "Book 2"}
          ]
        }
      )
    end

    it "answers success with different encoded characters" do
      body = "<catalog>B\xFFoks</catalog>".dup.force_encoding "UTF-8"
      expect(parser.call(body)).to be_success("catalog" => "B�oks")
    end

    it "answers failure when body is malformed" do
      expect(parser.call("bogus")).to be_failure(
        "Malformed XML: Content at the start of the document (got 'bogus')\n" \
        "Line: 1\nPosition: 5\nLast 80 unconsumed characters:\n"
      )
    end
  end
end
