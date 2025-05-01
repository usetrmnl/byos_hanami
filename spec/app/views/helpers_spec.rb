# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Helpers do
  subject(:helper) { described_class }

  describe ".field_for" do
    let(:record) { Data.define(:label).new label: "Test" }
    let(:attributes) { {label: "Other"} }

    it "answers nil for missing attributes key and no record" do
      expect(helper.field_for(:unknown, attributes)).to be(nil)
    end

    it "answers attribute value when found" do
      expect(helper.field_for(:label, attributes, record)).to eq("Other")
    end

    it "answers record value when attribute key is missing" do
      attributes.clear
      expect(helper.field_for(:label, attributes, record)).to eq("Test")
    end
  end

  describe ".human_at" do
    it "answers human date/time" do
      expect(helper.human_at(Time.utc(2025, 1, 2, 3, 4, 5))).to eq("January 02 2025 at 03:04 UTC")
    end

    it "answers nil if not set" do
      expect(helper.human_at(nil)).to be(nil)
    end
  end

  describe "#size" do
    it "answers size in bytes" do
      expect(helper.size(50)).to eq("50 B")
    end

    it "answers one megabyte" do
      expect(helper.size(1_048_576)).to eq("1 MB")
    end

    it "answers multiple megabytes" do
      expect(helper.size(2_097_152)).to eq("2 MB")
    end

    it "answers megabytes with two decimal precision" do
      expect(helper.size(2_500_111)).to eq("2.38 MB")
    end
  end
end
