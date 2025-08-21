# frozen_string_literal: true

require "hanami_helper"
require "mini_magick"

RSpec.describe Terminus::Aspects::Screens::Compressor do
  using Refinements::Pathname

  subject(:converter) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:bmp_path) { SPEC_ROOT.join "support/fixtures/test.png" }
    let(:png_path) { SPEC_ROOT.join "support/fixtures/test.png" }

    context "when PNG" do
      let(:path) { temp_dir.join "test.png" }

      before { png_path.copy path }

      it "remains a PNG" do
        converter.call png_path
        expect(MiniMagick::Image.open(path)).to have_attributes(type: "PNG")
      end

      it "answers PNG" do
        expect(converter.call(png_path)).to be_success(png_path)
      end
    end

    context "when BMP" do
      let(:path) { temp_dir.join "test.bmp" }

      before { bmp_path.copy path }

      it "becomes a PNG" do
        converter.call png_path
        expect(MiniMagick::Image.open(path)).to have_attributes(type: "PNG")
      end

      it "answers PNG" do
        expect(converter.call(path)).to be_success(temp_dir.join("test.png"))
      end
    end

    it "answers failure when compression fails" do
      path = temp_dir.join "test.bmp"
      mini_magick = class_double MiniMagick
      allow(mini_magick).to receive(:convert).and_raise MiniMagick::Error, "Danger!"
      converter = described_class.new(mini_magick:)

      expect(converter.call(path)).to be_failure("Danger!")
    end
  end
end
