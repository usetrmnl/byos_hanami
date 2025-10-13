# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Parts::Screen do
  subject(:part) { described_class.new value: screen, rendering: view.new.rendering }

  let(:screen) { Factory.structs[:screen, :with_image] }

  let :view do
    Class.new Hanami::View do
      config.paths = [Hanami.app.root.join("app/templates")]
      config.template = "n/a"
    end
  end

  describe "#dimensions" do
    it "answers default dimensions" do
      expect(part.dimensions).to eq("1x1")
    end

    context "with custom dimensions" do
      let(:screen) { Factory.structs[:screen, image_data: {metadata: {width: 800, height: 480}}] }

      it "answers custom width and height" do
        expect(part.dimensions).to eq("800x480")
      end
    end

    context "with no dimensions" do
      let(:screen) { Factory.structs[:screen, image_data: {metadata: {width: nil, height: nil}}] }

      it "answers custom width and height" do
        expect(part.dimensions).to eq("Unknown")
      end
    end
  end

  describe "#type" do
    it "answers type when MIME Type is defined" do
      expect(part.type).to eq("PNG")
    end

    context "with no image data" do
      let(:screen) { Factory.structs[:screen, image_data: {}] }

      it "answers unknown" do
        expect(part.type).to eq("Unknown")
      end
    end
  end
end
