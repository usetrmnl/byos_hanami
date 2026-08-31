# frozen_string_literal: true

require "hanami_helper"
require "rexml"

RSpec.describe Terminus::Aspects::Superfluid::Filters::QRCode do
  subject(:filter) { described_class }

  describe "#call" do
    let :build_attributes do
      lambda do |content|
        REXML::Document.new(content)
                       .root
                       .attributes
                       .each
                       .with_object({}) { |(key, value), all| all[key] = value }
      end
    end

    it "answers SVG with defaults" do
      attributes = build_attributes.call filter.call("Test")

      expect(attributes).to eq(
        "version" => "1.1",
        "xmlns" => "http://www.w3.org/2000/svg",
        "xmlns:xlink" => "http://www.w3.org/1999/xlink",
        "xmlns:ev" => "http://www.w3.org/2001/xml-events",
        "shape-rendering" => "crispEdges",
        "class" => "qr-code",
        "viewBox" => "0 0 231 231"
      )
    end

    it "answers SVG for size and 7% level" do
      attributes = build_attributes.call filter.call("Test", 11, "l")

      expect(attributes).to eq(
        "version" => "1.1",
        "xmlns" => "http://www.w3.org/2000/svg",
        "xmlns:xlink" => "http://www.w3.org/1999/xlink",
        "xmlns:ev" => "http://www.w3.org/2001/xml-events",
        "shape-rendering" => "crispEdges",
        "class" => "qr-code",
        "viewBox" => "0 0 231 231"
      )
    end

    it "answers SVG for size and invalid level" do
      attributes = build_attributes.call filter.call("Test", 11, "BOGUS")

      expect(attributes).to eq(
        "version" => "1.1",
        "xmlns" => "http://www.w3.org/2000/svg",
        "xmlns:xlink" => "http://www.w3.org/1999/xlink",
        "xmlns:ev" => "http://www.w3.org/2001/xml-events",
        "shape-rendering" => "crispEdges",
        "class" => "qr-code",
        "viewBox" => "0 0 231 231"
      )
    end

    it "answers SVG with width and height when view box is fixed (disabled)" do
      attributes = build_attributes.call filter.call("Test", 11, "", "fixed")

      expect(attributes).to eq(
        "version" => "1.1",
        "xmlns" => "http://www.w3.org/2000/svg",
        "xmlns:xlink" => "http://www.w3.org/1999/xlink",
        "xmlns:ev" => "http://www.w3.org/2001/xml-events",
        "shape-rendering" => "crispEdges",
        "class" => "qr-code",
        "height" => "231",
        "width" => "231"
      )
    end
  end
end
