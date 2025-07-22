# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Converter, :db do
  subject(:converter) { described_class.new }

  include_context "with temporary directory"

  describe "#call" do
    let(:model) { Factory[:model, mime_type: "image/bmp"] }
    let(:input_path) { SPEC_ROOT.join "support/fixtures/test.png" }
    let(:output_path) { temp_dir.join "test.bmp" }

    it "creates BMP screenshot" do
      converter.call model, input_path, output_path
      image = MiniMagick::Image.open output_path

      expect(image).to have_attributes(
        dimensions: [800, 480],
        exif: {},
        type: "BMP3",
        data: hash_including("depth" => 1)
      )
    end

    it "creates PNG screenshot" do
      model = Factory[:model, mime_type: "image/png"]
      converter.call model, input_path, temp_dir.join("test.png")
      image = MiniMagick::Image.open temp_dir.join("test.png")

      expect(image).to have_attributes(
        dimensions: [800, 480],
        exif: {},
        type: "PNG",
        data: hash_including("depth" => 1)
      )
    end

    it "answers image path" do
      expect(converter.call(model, input_path, output_path)).to be_success(output_path)
    end

    it "answers failure for invalid image type" do
      model = Factory[:model, mime_type: "image/bogus"]

      expect(converter.call(model, input_path, temp_dir)).to be_failure(
        %(Invalid MIME Type: "image/bogus". Use: "image/bmp" or "image/png".)
      )
    end

    it "answers failure when MiniMagick can't convert" do
      client = class_double MiniMagick
      allow(client).to receive(:convert).and_raise(MiniMagick::Error, "Danger!")
      converter = described_class.new(client:)

      expect(converter.call(model, input_path, output_path)).to be_failure("Danger!")
    end
  end
end
