# frozen_string_literal: true

require "hanami_helper"
require "mini_magick"

RSpec.describe Terminus::Aspects::Screens::ColorMapper do
  using Refinements::Pathname

  subject(:color_mapper) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "2x1.png" }

    it "creates one bit image" do
      color_mapper.call 1
      image = MiniMagick::Image.open path

      expect(image.data).to include(
        "colormap" => ["#000000FF", "#FFFFFFFF"],
        "depth" => 1,
        "geometry" => hash_including("width" => 4, "height" => 1),
        "mimeType" => "image/png",
        "type" => "Grayscale"
      )
    end

    context "with two bit image" do
      let(:path) { temp_dir.join "4x1.png" }

      it "creates image" do
        color_mapper.call 2
        image = MiniMagick::Image.open path

        expect(image.data).to include(
          "colormap" => ["#000000FF", "#555555FF", "#AAAAAAFF", "#FFFFFFFF"],
          "depth" => 2,
          "geometry" => hash_including("width" => 16, "height" => 1),
          "mimeType" => "image/png",
          "type" => "Grayscale"
        )
      end
    end

    context "with four bit image" do
      let(:path) { temp_dir.join "16x1.png" }

      it "creates image" do
        color_mapper.call 4

        image = MiniMagick::Image.open path

        expect(image.data).to include(
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
          "depth" => 4,
          "geometry" => hash_including("width" => 256, "height" => 1),
          "mimeType" => "image/png",
          "type" => "Grayscale"
        )
      end
    end

    it "answers logs debug message when bit depth is higher than four" do
      color_mapper.call 5
      expect(logger.reread).to match(/DEBUG.+Color map skipped for bit depth: 5\./)
    end

    it "answers non-existent path when bit depth is higher than four" do
      expect(color_mapper.call(5)).to be_success(Pathname.new(""))
    end

    it "answers path when file doesn't exist" do
      expect(color_mapper.call(1)).to be_success(path)
    end

    it "answers path when file does exist" do
      path.touch
      expect(color_mapper.call(1)).to be_success(path)
    end

    it "answers failure with command error status" do
      status = instance_double Process::Status, success?: false
      shell = class_double Open3
      allow(shell).to receive(:capture3).and_return(["", "Danger!", status])
      color_mapper = described_class.new(shell:)

      expect(color_mapper.call(1)).to match(Failure("Danger!"))
    end

    it "answers failure with invalid command" do
      color_mapper = described_class.new command: "bogus-magick"
      expect(color_mapper.call(1)).to match(Failure(/bogus-magick/))
    end
  end
end
