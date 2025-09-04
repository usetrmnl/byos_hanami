# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Mold do
  using Refinements::Struct

  subject :mold do
    described_class[
      model_id: 1,
      name: "test",
      label: "Test",
      content: "test",
      kind: :text,
      mime_type: "image/png",
      bit_depth: 4,
      rotation: 0,
      offset_x: 0,
      offset_y: 0,
      width: 800,
      height: 480
    ]
  end

  let(:model) { Factory.structs[:model, bit_depth: 1, colors: 2] }

  describe ".for" do
    it "answers instance with model attributes" do
      expect(described_class.for(model)).to eq(
        described_class[
          model_id: model.id,
          mime_type: "image/png",
          bit_depth: 1,
          colors: 2,
          rotation: 0,
          offset_x: 0,
          offset_y: 0,
          width: 800,
          height: 480
        ]
      )
    end

    it "answers instance with model and additional attributes" do
      expect(described_class.for(model, name: "test", kind: :text)).to eq(
        described_class[
          model_id: model.id,
          name: "test",
          kind: :text,
          mime_type: "image/png",
          bit_depth: 1,
          colors: 2,
          rotation: 0,
          offset_x: 0,
          offset_y: 0,
          width: 800,
          height: 480
        ]
      )
    end
  end

  describe "#crop" do
    it "answers width, height, x offset, and y offset" do
      expect(mold.with(offset_x: 10, offset_y: 20).crop).to eq("800x480+10+20")
    end
  end

  describe "#cropable?" do
    it "answers true if x offset is not zero" do
      expect(mold.with(offset_x: 1).cropable?).to be(true)
    end

    it "answers true if y offset is not zero" do
      expect(mold.with(offset_y: 1).cropable?).to be(true)
    end

    it "answers false if x and y offsets are zero" do
      expect(mold.cropable?).to be(false)
    end
  end

  describe "#dither" do
    it "answers none kind is text" do
      expect(mold.dither).to eq("None")
    end

    it "answers Floyd FloydSteinberg kind isn't text" do
      expect(mold.with(kind: :art).dither).to eq("FloydSteinberg")
    end
  end

  describe "#dimensions" do
    it "answers dimensions" do
      expect(mold.dimensions).to eq("800x480")
    end
  end

  describe "#filename" do
    it "answers filename" do
      expect(mold.filename).to eq("test.png")
    end
  end

  describe "#image_attributes" do
    it "answers image attributes for screen attachments" do
      expect(mold.image_attributes).to eq(model_id: 1, label: "Test", name: "test")
    end
  end

  describe "#rotatable?" do
    it "answers true when rotation is positive" do
      expect(mold.with(rotation: 1).rotatable?).to be(true)
    end

    it "answers false when rotation is zero" do
      expect(mold.rotatable?).to be(false)
    end
  end

  describe "#viewport" do
    it "answers viewport specific attributes" do
      viewport = {width: 800, height: 480}
      expect(mold.with(**viewport).viewport).to eq(viewport)
    end
  end
end
