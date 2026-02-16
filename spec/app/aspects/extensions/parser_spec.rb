# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Parser do
  subject(:parser) { described_class }

  describe ".from_csv" do
    it "answers success when body is nil" do
      expect(parser.from_csv(nil)).to be_success("source" => Success([]))
    end

    it "answers success when body is blank" do
      expect(parser.from_csv("")).to be_success("source" => Success([]))
    end

    it "answers success when body has no headers or rows" do
      expect(parser.from_csv("bogus")).to be_success("source" => Success([]))
    end

    it "answers success with valid headers and rows" do
      body = <<~BODY
        title,director
        Castle in the Sky,Hayao Miyazaki
      BODY

      expect(parser.from_csv(body)).to be_success(
        "source" => Success([{"director" => "Hayao Miyazaki", "title" => "Castle in the Sky"}])
      )
    end

    it "answers failure with invalid encoding" do
      body = "name,city\nJohn,New\xFFYork".dup.force_encoding "UTF-8"
      expect(parser.from_csv(body)).to be_failure("Invalid byte sequence in UTF-8 in line 2.")
    end

    it "answers failure with missing quote" do
      body = <<~BODY
        title,director
        "Castle in the Sky,Hayao Miyazaki
      BODY

      expect(parser.from_csv(body)).to be_failure("Unclosed quoted field in line 2.")
    end
  end

  describe ".from_image" do
    it "answers suceess" do
      expect(parser.from_image("https://test.io/test.png")).to be_success(
        "source" => Success("https://test.io/test.png")
      )
    end
  end

  describe ".from_json" do
    it "answers suceess when body is nil" do
      expect(parser.from_json(nil)).to be_success("source" => Success([]))
    end

    it "answers success when body is blank" do
      expect(parser.from_json("")).to be_success({"source" => Success([])})
    end

    it "answers success when body is a hash" do
      body = {test: "example"}.to_json
      expect(parser.from_json(body)).to be_success("source" => Success("test" => "example"))
    end

    it "answers success when body is an array" do
      body = [1, 2, 3].to_json
      expect(parser.from_json(body)).to be_success("source" => Success([1, 2, 3]))
    end

    it "answers failure with invalid encoding" do
      body = "test\xFF".dup.force_encoding "UTF-8"
      expect(parser.from_json(body)).to be_failure("Unexpected token 'test' at line 1 column 1.")
    end
  end

  describe ".from_text" do
    it "answers suceess when body is nil" do
      expect(parser.from_text(nil)).to be_success("source" => Success([]))
    end

    it "answers success when body is blank" do
      expect(parser.from_text("")).to be_success({"source" => Success([])})
    end

    it "answers success with single line" do
      expect(parser.from_text("test")).to be_success("source" => Success(["test"]))
    end

    it "answers success with multiple lines" do
      expect(parser.from_text("one\ntwo\nthree")).to be_success(
        "source" => Success(%w[one two three])
      )
    end

    it "answers failure with invalid encoding" do
      body = "test\xFF".dup.force_encoding "UTF-8"
      expect(parser.from_text(body)).to be_failure("Invalid byte sequence in utf-8.")
    end
  end

  describe ".from_xml" do
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
      expect(parser.from_xml(nil)).to be_success("source" => Success({}))
    end

    it "answers success when body is blank" do
      expect(parser.from_xml("")).to be_success("source" => Success({}))
    end

    it "answers success with valid body" do
      expect(parser.from_xml(body)).to be_success(
        "source" => Success(
          {
            "catalog" => {
              "book" => [
                {"title" => "Book 1"},
                {"title" => "Book 2"}
              ]
            }

          }
        )
      )
    end

    it "answers success with different encoded characters" do
      body = "<catalog>B\xFFoks</catalog>".dup.force_encoding "UTF-8"
      expect(parser.from_xml(body)).to be_success("source" => Success({"catalog" => "B�oks"}))
    end

    it "answers failure when body is malformed" do
      expect(parser.from_xml("bogus")).to be_failure(
        "Malformed XML: Content at the start of the document (got 'bogus')\n" \
        "Line: 1\nPosition: 5\nLast 80 unconsumed characters:\n"
      )
    end
  end
end
