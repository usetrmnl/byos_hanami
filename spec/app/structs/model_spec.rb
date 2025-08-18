# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Model do
  subject(:model) { Factory.structs[:model, offset_x: 10, offset_y: 20] }

  describe "#crop" do
    it "answers width, height, x offset, and y offset" do
      expect(model.crop).to eq("800x480+10+20")
    end
  end

  describe "#cropable?" do
    it "answers true if x offset is not zero" do
      model = Factory.structs[:model, offset_x: 1, offset_y: 0]
      expect(model.cropable?).to be(true)
    end

    it "answers true if y offset is not zero" do
      model = Factory.structs[:model, offset_x: 0, offset_y: 1]
      expect(model.cropable?).to be(true)
    end

    it "answers false if x and y offsets are zero" do
      model = Factory.structs[:model, offset_x: 0, offset_y: 0]
      expect(model.cropable?).to be(false)
    end
  end

  describe "#dimensions" do
    it "answers dimensions" do
      expect(model.dimensions).to eq("800x480")
    end
  end

  describe "#rotatable?" do
    it "answers true when rotation is positive" do
      model = Factory.structs[:model, rotation: 1]
      expect(model.rotatable?).to be(true)
    end

    it "answers false when rotation is zero" do
      model = Factory.structs[:model, rotation: 0]
      expect(model.rotatable?).to be(false)
    end
  end
end
