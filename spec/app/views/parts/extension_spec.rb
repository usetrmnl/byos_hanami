# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Parts::Extension do
  subject(:part) { described_class.new value: extension, rendering: view.new.rendering }

  let :extension do
    Factory.structs[:extension, kind: "poll", mode: "light", verb: "get", repeat_type: "none"]
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

  describe "#fields_field" do
    it "answers filled hash string" do
      allow(extension).to receive(:fields).and_return(label: "Test", description: "A test.")
      expect(part.fields_field).to eq(%({"label":"Test","description":"A test."}))
    end

    it "answers empty hash string when empty" do
      allow(extension).to receive(:fields).and_return({})
      expect(part.fields_field).to eq("{}")
    end

    it "answers empty hash string when nil" do
      expect(part.fields_field).to eq("{}")
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

  describe "#headers_field" do
    it "answers filled hash string" do
      allow(extension).to receive(:headers).and_return(
        "Accept" => "application/json",
        "Accept-Encoding" => "deflate,gzip"
      )

      expect(part.headers_field).to eq(
        %({"Accept":"application/json","Accept-Encoding":"deflate,gzip"})
      )
    end

    it "answers empty hash string when empty" do
      allow(extension).to receive(:headers).and_return({})
      expect(part.headers_field).to eq("{}")
    end

    it "answers empty hash string when nil" do
      expect(part.headers_field).to eq("{}")
    end
  end

  describe "#poll_body_field" do
    it "answers filled hash string" do
      allow(extension).to receive(:poll_body).and_return(sort: :name, limit: 5)
      expect(part.poll_body_field).to eq(%({"sort":"name","limit":5}))
    end

    it "answers empty hash string when empty" do
      allow(extension).to receive(:poll_body).and_return({})
      expect(part.poll_body_field).to eq("{}")
    end

    it "answers empty hash string when nil" do
      expect(part.poll_body_field).to eq("{}")
    end
  end

  describe "#repeat_days_field" do
    it "answers filled array string" do
      allow(extension).to receive(:repeat_days).and_return(%w[monday tuesday wednesday])
      expect(part.repeat_days_field).to eq("monday,tuesday,wednesday")
    end

    it "answers empty array string when empty" do
      allow(extension).to receive(:repeat_days).and_return([])
      expect(part.repeat_days_field).to eq("")
    end

    it "answers empty array string when nil" do
      expect(part.repeat_days_field).to eq("")
    end
  end

  describe "#static_body_field" do
    it "answers filled hash string" do
      allow(extension).to receive(:static_body).and_return(one: 1, two: 2)
      expect(part.static_body_field).to eq(%({"one":1,"two":2}))
    end

    it "answers empty hash string when empty" do
      allow(extension).to receive(:static_body).and_return({})
      expect(part.static_body_field).to eq("{}")
    end

    it "answers empty hash string when nil" do
      expect(part.static_body_field).to eq("{}")
    end
  end
end
