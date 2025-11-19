# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Model do
  subject :model do
    Factory.structs[:model, name: "test", label: "Test", bit_depth: 2]
  end

  describe "#liquid_attributes" do
    it "answers liquid specific attributes" do
      expect(model.liquid_attributes).to eq(bit_depth: 2, name: "test", orientation: "landscape")
    end
  end

  describe "#orientation" do
    it "answers landscape when rotation is zero" do
      expect(model.orientation).to eq("landscape")
    end

    it "answers portrait when rotation is non-zero" do
      model = Factory.structs[:model, rotation: 90]
      expect(model.orientation).to eq("portrait")
    end
  end
end
