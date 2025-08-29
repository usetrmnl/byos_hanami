# frozen_string_literal: true

require "hanami_helper"
require "mini_magick"

RSpec.describe Terminus::Aspects::Screens::Converter do
  using Refinements::Struct

  subject(:converter) { described_class.new }

  include_context "with temporary directory"
  include_context "with screen mold"

  describe "#call" do
    before do
      mold.merge! input_path: SPEC_ROOT.join("support/fixtures/test.png"),
                  output_path: temp_dir.join("test.png")
    end

    it "converts to 1-bit BMP image" do
      converter.call mold.with(mime_type: "image/bmp")
      image = MiniMagick::Image.open mold.output_path

      expect(image).to have_attributes(
        dimensions: [800, 480],
        exif: {},
        type: "BMP3",
        data: hash_including("depth" => 1)
      )
    end

    it "converts to 1-bit PNG image" do
      converter.call mold
      image = MiniMagick::Image.open mold.output_path

      expect(image).to have_attributes(
        dimensions: [800, 480],
        exif: {},
        type: "PNG",
        data: hash_including("depth" => 1)
      )
    end

    it "answers image path" do
      expect(converter.call(mold)).to be_success(mold.output_path)
    end

    it "answers failure for invalid MIME Type" do
      result = converter.call mold.with(mime_type: "image/tiff")
      expect(result).to be_failure("Unsupported MIME Type: image/tiff.")
    end
  end
end
