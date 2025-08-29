# frozen_string_literal: true

require "hanami_helper"
require "mini_magick"

RSpec.describe Terminus::Aspects::Screens::Converters::BMP do
  using Refinements::Struct

  subject(:converter) { described_class.new }

  include_context "with temporary directory"
  include_context "with screen mold"

  describe "#call" do
    before do
      mold.merge! input_path: SPEC_ROOT.join("support/fixtures/test.bmp"),
                  output_path: temp_dir.join("test.bmp")
    end

    it "converts image" do
      converter.call mold
      image = MiniMagick::Image.open mold.output_path

      expect(image).to have_attributes(
        dimensions: [800, 480],
        exif: {},
        type: "BMP3",
        data: hash_including(
          "depth" => 1,
          "geometry" => {"width" => 800, "height" => 480, "x" => 0, "y" => 0},
          "mimeType" => "image/bmp",
          "type" => "Bilevel"
        )
      )
    end

    it "answers path" do
      expect(converter.call(mold)).to be_success(mold.output_path)
    end

    it "answers failure when MiniMagick can't convert" do
      mini_magick = class_double MiniMagick
      allow(mini_magick).to receive(:convert).and_raise(MiniMagick::Error, "Danger!")
      converter = described_class.new(mini_magick:)

      expect(converter.call(mold)).to be_failure("Danger!")
    end
  end
end
