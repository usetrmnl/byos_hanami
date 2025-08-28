# frozen_string_literal: true

require "hanami_helper"
require "mini_magick"

RSpec.describe Terminus::Aspects::Screens::Converters::PNG do
  subject(:converter) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:model) { Factory.structs[:model, bit_depth: 1] }
    let(:input_path) { SPEC_ROOT.join "support/fixtures/test.png" }
    let(:output_path) { temp_dir.join "test.png" }

    it "converts to one bit image" do
      converter.call model, input_path, temp_dir.join("test.png")
      image = MiniMagick::Image.open temp_dir.join("test.png")

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

    context "with two bit model" do
      let(:model) { Factory.structs[:model, bit_depth: 2] }

      it "converts image" do
        converter.call model, input_path, temp_dir.join("test.png")
        image = MiniMagick::Image.open temp_dir.join("test.png")

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
    end

    context "with four bit model" do
      let(:model) { Factory.structs[:model, bit_depth: 4] }

      it "converts image" do
        converter.call model, input_path, temp_dir.join("test.png")
        image = MiniMagick::Image.open temp_dir.join("test.png")

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
    end

    context "with higher that four bit depth" do
      let(:model) { Factory.structs[:model, bit_depth: 8] }

      it "converts image" do
        converter.call model, input_path, temp_dir.join("test.png")
        image = MiniMagick::Image.open temp_dir.join("test.png")

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
    end

    context "with rotation" do
      let(:model) { Factory.structs[:model, bit_depth: 1, rotation: 90] }

      it "converts image" do
        converter.call model, input_path, temp_dir.join("test.png")
        image = MiniMagick::Image.open temp_dir.join("test.png")

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
    end

    context "with offsets" do
      let(:model) { Factory.structs[:model, bit_depth: 1, offset_x: 10, offset_y: 20] }

      it "converts image" do
        converter.call model, input_path, temp_dir.join("test.png")
        image = MiniMagick::Image.open temp_dir.join("test.png")

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
    end

    it "answers path" do
      expect(converter.call(model, input_path, output_path)).to be_success(output_path)
    end

    it "answers failure when MiniMagick can't convert" do
      mini_magick = class_double MiniMagick
      allow(mini_magick).to receive(:convert).and_raise(MiniMagick::Error, "Danger!")
      converter = described_class.new(mini_magick:)

      expect(converter.call(model, input_path, output_path)).to be_failure("Danger!")
    end
  end
end
