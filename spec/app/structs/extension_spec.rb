# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Extension do
  subject(:extension) { Factory.structs[:extension, name: "test", label: "Test"] }

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
end
