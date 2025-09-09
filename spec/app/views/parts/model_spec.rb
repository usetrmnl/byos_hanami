# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Parts::Model do
  subject(:part) { described_class.new value: model, rendering: view.new.rendering }

  let(:model) { Factory.structs[:model] }

  let :view do
    Class.new Hanami::View do
      config.paths = [Hanami.app.root.join("app/templates")]
      config.template = "n/a"
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
