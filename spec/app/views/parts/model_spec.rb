# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Parts::Model do
  subject(:part) { described_class.new value: model, rendering: Terminus::View.new.rendering }

  let(:model) { Factory.structs[:model] }

  let :view do
    Class.new Hanami::View do
      config.paths = [Hanami.app.root.join("app/templates")]
      config.template = "n/a"
    end
  end

  describe "#alpine_palettes" do
    it "answers filled array string" do
      allow(model).to receive(:palette_ids).and_return(%w[bw gray-4 gray-16])
      expect(part.alpine_palettes).to eq(%(['bw','gray-4','gray-16']))
    end

    it "answers empty array string when empty" do
      allow(model).to receive(:palette_ids).and_return([])
      expect(part.alpine_palettes).to eq("[]")
    end

    it "answers empty array string when nil" do
      expect(part.alpine_palettes).to eq("[]")
    end
  end

  describe "#formatted_css" do
    it "answers empty string when attributes are empty" do
      expect(part.formatted_css).to eq("")
    end

    it "answers formatted code when attributes exist" do
      allow(model).to receive(:css).and_return(
        {
          classes: {
            size: "screen--lg",
            device: "screen--v2"
          }
        }
      )

      expect(part.formatted_css).to eq(<<~JSON.strip)
        {
          "classes": {
            "size": "screen--lg",
            "device": "screen--v2"
          }
        }
      JSON
    end
  end

  describe "#dimensions" do
    it "answers default dimensions" do
      expect(part.dimensions).to eq("800x480")
    end

    context "with custom dimensions" do
      let(:model) { Factory.structs[:model, width: 400, height: 240] }

      it "answers custom width and height" do
        expect(part.dimensions).to eq("400x240")
      end
    end
  end

  describe "#kind_label" do
    it "answers capitalized label" do
      expect(part.kind_label).to eq("Terminus")
    end

    context "with byod" do
      let(:model) { Factory.structs[:model, kind: "byod"] }

      it "answers upcase" do
        expect(part.kind_label).to eq("BYOD")
      end
    end

    context "with trmnl" do
      let(:model) { Factory.structs[:model, kind: "trmnl"] }

      it "answers upcase" do
        expect(part.kind_label).to eq("TRMNL")
      end
    end
  end

  describe "#palettes" do
    it "answers sentence when IDs are present" do
      allow(model).to receive(:palette_ids).and_return(%w[bw gray-4 gray-16])
      expect(part.palettes).to eq("bw, gray-4, and gray-16")
    end

    it "answers empty string when IDs are empty" do
      expect(part.palettes).to eq("")
    end
  end

  describe "#type" do
    it "answers type when MIME Type is defined" do
      expect(part.type).to eq("PNG")
    end

    context "with no image data" do
      let(:model) { Factory.structs[:model, mime_type: nil] }

      it "answers unknown" do
        expect(part.type).to eq("Unknown")
      end
    end
  end
end
