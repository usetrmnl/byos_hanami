# frozen_string_literal: true

require "hanami_helper"
require "mini_magick"

RSpec.describe Terminus::Aspects::Screens::Converters::BMP do
  subject(:converter) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:model) { Factory.structs[:model, bit_depth: 1, colors: 2] }
    let(:input_path) { SPEC_ROOT.join "support/fixtures/test.png" }
    let(:output_path) { temp_dir.join "test.png" }

    it "converts image" do
      converter.call model, input_path, temp_dir.join("test.png")
      image = MiniMagick::Image.open temp_dir.join("test.png")

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
