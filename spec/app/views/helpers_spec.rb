# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Helpers do
  subject(:helper) { described_class }

  include_context "with application dependencies"

  describe ".boolean" do
    it "answers green span when true" do
      expect(helper.boolean(true)).to eq(%(<span class="bit-text-green">true</span>))
    end

    it "answers red span when true" do
      expect(helper.boolean(false)).to eq(%(<span class="bit-text-red">false</span>))
    end
  end

  describe ".field_for" do
    let(:record) { Data.define(:label).new label: "Test" }
    let(:attributes) { {label: "Other"} }

    it "answers nil for missing attributes key and no record" do
      expect(helper.field_for(:unknown, attributes)).to be(nil)
    end

    it "answers attribute value when found" do
      expect(helper.field_for(:label, attributes, record)).to eq("Other")
    end

    it "answers record value when attribute is missing" do
      attributes.clear
      expect(helper.field_for(:label, attributes, record)).to eq("Test")
    end

    it "answers formatted Sequel time string when an instance of SQL Time" do
      record = Data.define(:start_at).new start_at: Sequel::SQLTime.new(2025, 1, 1, 10, 5, 1)
      expect(helper.field_for(:start_at, attributes, record)).to eq("10:05:01")
    end

    it "answers formatted time string when an instance of Time" do
      record = Data.define(:published_at).new published_at: Time.local(2025, 1, 2, 3, 4)
      expect(helper.field_for(:published_at, attributes, record)).to eq("2025-01-02T03:04")
    end
  end

  describe "#git_sha_link" do
    it "answers link" do
      expect(helper.git_sha_link).to eq(
        %(<a class="link" href="https://github.com/usetrmnl/byos_hanami/commit/abcdefghijkl">) \
        "abcdefghijkl</a>"
      )
    end
  end

  describe "#git_tag_link" do
    it "answers link" do
      expect(helper.git_tag_link).to eq(
        %(<a class="link" href="https://github.com/usetrmnl/byos_hanami/releases/tag/1.2.3">) \
        "1.2.3</a>"
      )
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

  describe ".human_time" do
    it "answers human date/time" do
      expect(helper.human_time(Time.utc(2025, 1, 2, 3, 4, 5))).to eq("03:04 AM")
    end

    it "answers nil if not set" do
      expect(helper.human_time(nil)).to be(nil)
    end
  end

  describe "#select_options_for" do
    it "answers record options" do
      record = Data.define(:id, :label).new 1, "Test"
      expect(helper.select_options_for([record])).to eq([["Select...", ""], ["Test", 1]])
    end

    it "answers record options with custom label" do
      record = Data.define(:id, :title).new 1, "Test"

      expect(helper.select_options_for([record], label: :title)).to eq(
        [
          ["Select...", ""],
          ["Test", 1]
        ]
      )
    end

    it "answers record options with custom ID" do
      record = Data.define(:name, :label).new "test", "Test"

      expect(helper.select_options_for([record], id: :name)).to eq(
        [
          ["Select...", ""],
          ["Test", "test"]
        ]
      )
    end

    it "answers prompt when given an empty array" do
      expect(helper.select_options_for([])).to contain_exactly(["Select...", ""])
    end
  end

  describe "#size" do
    it "answers zero if nil" do
      expect(helper.size(nil)).to eq("0.0 B")
    end

    it "answers zero if zero" do
      expect(helper.size(0)).to eq("0.0 B")
    end

    it "answers bytes" do
      expect(helper.size(50)).to eq("50.0 B")
    end

    it "answers kilobytes with single decimal precision" do
      expect(helper.size(1_130)).to eq("1.1 KB")
    end

    it "answers kilobytes with two decimal precision" do
      expect(helper.size(2_444)).to eq("2.39 KB")
    end

    it "answers megabytes" do
      expect(helper.size(1_572_864)).to eq("1.5 MB")
    end

    it "answers gigabytes" do
      expect(helper.size(1_073_741_824)).to eq("1.0 GB")
    end

    it "answers terabytes" do
      expect(helper.size(1_099_511_627_776)).to eq("1.0 TB")
    end
  end
end
