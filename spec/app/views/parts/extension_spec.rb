# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Parts::Extension do
  subject(:part) { described_class.new value: extension, rendering: view.new.rendering }

  let :extension do
    Factory.structs[:extension, kind: "poll", verb: "get", unit: "none"]
  end

  let :view do
    Class.new Hanami::View do
      config.paths = [Hanami.app.root.join("app/templates")]
      config.template = "n/a"
    end
  end

  describe "#alpine_tags" do
    it "answers filled array string" do
      allow(extension).to receive(:tags).and_return(%w[one two three])
      expect(part.alpine_tags).to eq(%(['one','two','three']))
    end

    it "answers empty array string when empty" do
      allow(extension).to receive(:tags).and_return([])
      expect(part.alpine_tags).to eq("[]")
    end

    it "answers empty array string when nil" do
      expect(part.alpine_tags).to eq("[]")
    end
  end

  describe "#formatted_body" do
    it "answers filled hash string" do
      allow(extension).to receive(:body).and_return(sort: :name, limit: 5)

      expect(part.formatted_body).to eq(<<~JSON.strip)
        {
          "sort": "name",
          "limit": 5
        }
      JSON
    end

    it "answers empty string when empty" do
      allow(extension).to receive(:body).and_return({})
      expect(part.formatted_body).to eq("")
    end

    it "answers empty string when nil" do
      expect(part.formatted_body).to eq("")
    end
  end

  describe "#formatted_data" do
    it "answers filled hash string" do
      allow(extension).to receive(:data).and_return(label: "Test", description: "A test.")

      expect(part.formatted_data).to eq(<<~JSON.strip)
        {
          "label": "Test",
          "description": "A test."
        }
      JSON
    end

    it "answers empty string when empty" do
      allow(extension).to receive(:data).and_return({})
      expect(part.formatted_data).to eq("")
    end

    it "answers empty string when nil" do
      expect(part.formatted_data).to eq("")
    end
  end

  describe "#formatted_days" do
    it "answers filled array string" do
      allow(extension).to receive(:days).and_return(%w[monday tuesday wednesday])
      expect(part.formatted_days).to eq("monday,tuesday,wednesday")
    end

    it "answers empty array string when empty" do
      allow(extension).to receive(:days).and_return([])
      expect(part.formatted_days).to eq("")
    end

    it "answers empty array string when nil" do
      expect(part.formatted_days).to eq("")
    end
  end

  describe "#formatted_fields" do
    it "answers filled hash string" do
      allow(extension).to receive(:fields).and_return(label: "Test", description: "A test.")

      expect(part.formatted_fields).to eq(<<~JSON.strip)
        {
          "label": "Test",
          "description": "A test."
        }
      JSON
    end

    it "answers empty string when empty" do
      allow(extension).to receive(:fields).and_return({})
      expect(part.formatted_fields).to eq("")
    end

    it "answers empty string when nil" do
      expect(part.formatted_fields).to eq("")
    end
  end

  describe "#formatted_headers" do
    it "answers filled hash string" do
      allow(extension).to receive(:headers).and_return(
        "Accept" => "application/json",
        "Accept-Encoding" => "deflate,gzip"
      )

      expect(part.formatted_headers).to eq(<<~JSON.strip)
        {
          "Accept": "application/json",
          "Accept-Encoding": "deflate,gzip"
        }
      JSON
    end

    it "answers empty string when empty" do
      allow(extension).to receive(:headers).and_return({})
      expect(part.formatted_headers).to eq("")
    end

    it "answers empty string when nil" do
      expect(part.formatted_headers).to eq("")
    end
  end

  describe "#formatted_start_at" do
    it "answers date and time when existing" do
      expect(part.formatted_start_at).to eq("2025-01-01T00:00:00")
    end

    it "answers default date and time when missing" do
      allow(extension).to receive(:start_at).and_return(nil)
      expect(part.formatted_start_at).to eq("2025-01-01T00:00:00")
    end
  end

  describe "formatted_uris" do
    it "answers a string with each seperated by a new line" do
      allow(extension).to receive(:uris).and_return(%w[https://one.io https://two.io])

      expect(part.formatted_uris).to eq(<<~CONTENT.strip)
        https://one.io
        https://two.io
      CONTENT
    end

    it "answers a string when empty" do
      allow(extension).to receive(:uris).and_return([])
      expect(part.formatted_uris).to eq("")
    end
  end
end
