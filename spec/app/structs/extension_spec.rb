# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Extension do
  subject :extension do
    Factory.structs[:extension, id: 1, name: "test", label: "Test", interval: 5, unit: "minute"]
  end

  describe "#screen_name" do
    it "answers name" do
      expect(extension.screen_name).to eq("extension-test")
    end
  end

  describe "#screen_label" do
    it "answers label" do
      expect(extension.screen_label).to eq("Extension Test")
    end
  end

  describe "#screen_attributes" do
    it "answers attributes" do
      expect(extension.screen_attributes).to eq(label: "Extension Test", name: "extension-test")
    end
  end

  describe "#to_cron" do
    it "answers schedule when set" do
      expect(extension.to_cron).to eq("*/5 * * * * UTC")
    end

    it "answers empty string when there is no schedule" do
      expect(Factory.structs[:extension].to_cron).to eq("")
    end
  end

  describe "#to_schedule" do
    it "answers schedule" do
      expect(extension.to_schedule).to eq(
        [
          "extension-test",
          {
            cron: "*/5 * * * * UTC",
            class: Terminus::Jobs::Batches::Extension,
            args: [1],
            description: "The Test extension update schedule."
          }
        ]
      )
    end
  end
end
