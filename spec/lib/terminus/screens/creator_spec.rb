# frozen_string_literal: true

require "hanami_helper"
require "mini_magick"

RSpec.describe Terminus::Screens::Creator do
  subject(:saver) { described_class.new }

  include_context "with temporary directory"

  describe "#call" do
    let(:content) { Base64.strict_encode64 SPEC_ROOT.join("support/fixtures/test.png").read }
    let(:output_path) { temp_dir.join "test.png" }

    it "saves HTML as image" do
      saver.call output_path, content: "<h1>Test</h1>"
      image = MiniMagick::Image.open output_path

      expect(image).to have_attributes(width: 800, height: 480, type: "PNG", exif: {})
    end

    it "saves URI as image" do
      saver.call output_path, uri: SPEC_ROOT.join("support/fixtures/test.png"), dimensions: "50x50"

      image = MiniMagick::Image.open output_path

      expect(image).to have_attributes(width: 50, height: 50, type: "PNG", exif: {})
    end

    it "saves encoded image" do
      data = Base64.strict_encode64 SPEC_ROOT.join("support/fixtures/test.png").read
      saver.call output_path, data:, dimensions: "50x50"
      image = MiniMagick::Image.open output_path

      expect(image).to have_attributes(width: 50, height: 50, type: "PNG", exif: {})
    end

    it "answers failure with invalid parameters" do
      expect(saver.call(output_path, bogus: :danger)).to be_failure(
        "Invalid screen parameters: {bogus: :danger}."
      )
    end
  end
end
