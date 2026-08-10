# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Parts::Screen do
  subject(:part) { described_class.new value: screen, rendering: Terminus::View.new.rendering }

  let(:screen) { Factory.structs[:screen, :with_image] }

  describe "#design_link" do
    it "answers link when template exists" do
      screen.define_singleton_method :template do
        Factory.structs[:screen_template, id: 1, label: "Test"]
      end

      expect(part.design_link).to eq(%(<a href="/designs/1">Test</a>))
    end

    it "answers none when template doesn't exist" do
      screen.define_singleton_method(:template) { nil }
      expect(part.design_link).to eq("None")
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

  describe "#extension_link" do
    it "answers link when extension exists" do
      screen.define_singleton_method :extension do
        Factory.structs[:extension, id: 1, label: "Test"]
      end

      expect(part.extension_link).to eq(%(<a href="/extensions/1/edit">Test</a>))
    end

    it "answers none when extension doesn't exist" do
      screen.define_singleton_method(:extension) { nil }
      expect(part.extension_link).to eq("None")
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
