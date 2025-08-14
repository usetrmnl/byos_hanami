# frozen_string_literal: true

require "hanami_helper"
require "mini_magick"

RSpec.describe Terminus::Aspects::Screens::ColorMapper do
  using Refinements::Pathname

  subject(:color_mapper) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "2_bit.png" }

    it "creates image" do
      color_mapper.call
      image = MiniMagick::Image.open path

      expect(image.data).to include(
        "colormap" => ["#000000FF", "#555555FF", "#AAAAAAFF", "#FFFFFFFF"],
        "depth" => 2,
        "geometry" => {"width" => 16, "height" => 1, "x" => 0, "y" => 0},
        "mimeType" => "image/png",
        "type" => "Grayscale"
      )
    end

    it "answers path when file doesn't exist" do
      expect(color_mapper.call).to be_success(path)
    end

    it "answers path when file does exist" do
      path.touch
      expect(color_mapper.call).to be_success(path)
    end

    it "answers failure when command fails" do
      color_mapper = described_class.new command: %w[magick -size]

      expect(color_mapper.call).to match(Failure(/MissingArgument/))
    end
  end
end
