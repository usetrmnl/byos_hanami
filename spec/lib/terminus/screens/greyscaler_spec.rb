# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Screens::Greyscaler do
  subject(:greyscaler) { described_class.new randomizer: proc { "abc123" } }

  include_context "with temporary directory"

  describe "#call" do
    let(:input_path) { SPEC_ROOT.join "support/fixtures/test.png" }
    let(:output_path) { temp_dir.join "%<name>s.bmp" }

    it "creates screenshot" do
      greyscaler.call input_path, output_path
      image = MiniMagick::Image.open temp_dir.join("abc123.bmp")

      expect(image).to have_attributes(
        dimensions: [1, 1],
        exif: {},
        type: "BMP3",
        data: hash_including("depth" => 1, "baseDepth" => 1)
      )
    end

    it "answers unique image path" do
      expect(greyscaler.call(input_path, output_path)).to eq(temp_dir.join("abc123.bmp"))
    end

    it "answers identical image path" do
      output_path = temp_dir.join "test.bmp"
      expect(greyscaler.call(input_path, output_path)).to eq(output_path)
    end
  end
end
