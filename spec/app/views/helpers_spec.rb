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
  end
end
