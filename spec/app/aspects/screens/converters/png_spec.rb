# frozen_string_literal: true

require "hanami_helper"
require "mini_magick"

RSpec.describe Terminus::Aspects::Screens::Converters::PNG do
  using Refinements::Struct

  subject(:converter) { described_class.new }

  include_context "with temporary directory"
  include_context "with screen mold"

  describe "#call" do
    before do
      mold.merge! input_path: SPEC_ROOT.join("support/fixtures/test.png"),
                  output_path: temp_dir.join("test.png")
    end

    it "converts to one bit image" do
      converter.call mold
      image = MiniMagick::Image.open mold.output_path

      expect(image).to have_attributes(
        dimensions: [800, 480],
        exif: {},
        type: "PNG",
        data: hash_including(
          "colormap" => %w[#000000FF #FFFFFFFF],
          "colorspace" => "Gray",
          "depth" => 1,
          "mimeType" => "image/png",
          "type" => "Grayscale"
        )
      )
    end

    it "converts to two bit image" do
      converter.call mold.with(bit_depth: 2)
      image = MiniMagick::Image.open mold.output_path

      expect(image).to have_attributes(
        dimensions: [800, 480],
        exif: {},
        type: "PNG",
        data: hash_including(
          "colormap" => ["#000000FF", "#555555FF", "#AAAAAAFF", "#FFFFFFFF"],
          "colorspace" => "Gray",
          "depth" => 2,
          "geometry" => {"width" => 800, "height" => 480, "x" => 0, "y" => 0},
          "mimeType" => "image/png",
          "type" => "Grayscale"
        )
      )
    end

    it "converts to four bit image" do
      converter.call mold.with(bit_depth: 4)
      image = MiniMagick::Image.open mold.output_path

      expect(image).to have_attributes(
        dimensions: [800, 480],
        exif: {},
        type: "PNG",
        data: hash_including(
          "colormap" => %w[
            #000000FF
            #111111FF
            #222222FF
            #333333FF
            #444444FF
            #555555FF
            #666666FF
            #777777FF
            #888888FF
            #999999FF
            #AAAAAAFF
            #BBBBBBFF
            #CCCCCCFF
            #DDDDDDFF
            #EEEEEEFF
            #FFFFFFFF
          ],
          "colorspace" => "Gray",
          "depth" => 4,
          "mimeType" => "image/png",
          "type" => "Grayscale"
        )
      )
    end

    it "converts to higher than four bit image" do
      converter.call mold.with(bit_depth: 8)
      image = MiniMagick::Image.open mold.output_path

      expect(image).to have_attributes(
        dimensions: [800, 480],
        exif: {},
        type: "PNG",
        data: hash_including(
          "colorspace" => "Gray",
          "depth" => 8,
          "geometry" => {"width" => 800, "height" => 480, "x" => 0, "y" => 0},
          "mimeType" => "image/png",
          "type" => "Grayscale"
        )
      )
    end

    it "rotates image" do
      converter.call mold.with(rotation: 90)
      image = MiniMagick::Image.open mold.output_path

      expect(image).to have_attributes(
        dimensions: [800, 480],
        exif: {},
        type: "PNG",
        data: hash_including(
          "colormap" => %w[#000000FF #FFFFFFFF],
          "colorspace" => "Gray",
          "depth" => 1,
          "mimeType" => "image/png",
          "type" => "Grayscale"
        )
      )
    end

    it "offsets image" do
      converter.call mold.with(offset_x: 10, offset_y: 20)
      image = MiniMagick::Image.open mold.output_path

      expect(image).to have_attributes(
        dimensions: [790, 460],
        exif: {},
        type: "PNG",
        data: hash_including(
          "colormap" => %w[#000000FF #FFFFFFFF],
          "colorspace" => "Gray",
          "depth" => 1,
          "mimeType" => "image/png",
          "type" => "Grayscale"
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
