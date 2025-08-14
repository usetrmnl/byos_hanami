# frozen_string_literal: true

require "hanami_helper"
require "mini_magick"

RSpec.describe Terminus::Aspects::Screens::Converter do
  subject(:converter) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:input_path) { SPEC_ROOT.join "support/fixtures/test.png" }

    it "converts to 1-bit BMP image" do
      model = Factory.structs[:model, bit_depth: 1, colors: 2, mime_type: "image/bmp"]
      output_path = temp_dir.join "test.bmp"

      converter.call model, input_path, output_path

      expect(MiniMagick::Image.open(output_path)).to have_attributes(
        dimensions: [800, 480],
        exif: {},
        type: "BMP3",
        data: hash_including("depth" => 1)
      )
    end

    it "converts to 1-bit PNG image" do
      model = Factory.structs[:model, bit_depth: 1, colors: 2, mime_type: "image/png"]
      output_path = temp_dir.join "test.png"

      converter.call model, input_path, output_path

      expect(MiniMagick::Image.open(output_path)).to have_attributes(
        dimensions: [800, 480],
        exif: {},
        type: "PNG",
        data: hash_including("depth" => 1)
      )
    end

    it "converts to 2-bit PNG image" do
      model = Factory.structs[:model, bit_depth: 2, colors: 4, mime_type: "image/png"]
      output_path = temp_dir.join "test.png"

      converter.call model, input_path, output_path

      expect(MiniMagick::Image.open(output_path)).to have_attributes(
        dimensions: [800, 480],
        exif: {},
        type: "PNG",
        data: hash_including("depth" => 2)
      )
    end

    it "answers image path" do
      model = Factory.structs[:model, bit_depth: 1, colors: 2, mime_type: "image/bmp"]
      output_path = temp_dir.join "test.bmp"

      result = converter.call model, input_path, output_path

      expect(result).to be_success(output_path)
    end

    it "answers failure for invalid model" do
      model = Factory[:model, mime_type: "image/bogus"]

      expect(converter.call(model, input_path, temp_dir)).to be_failure(
        "Unsupported MIME Type for model: #{model.id}."
      )
    end
  end
end
