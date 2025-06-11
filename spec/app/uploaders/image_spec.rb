# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Uploaders::Image do
  subject(:uploader) { described_class }

  describe "#call" do
    let(:attacher) { uploader::Attacher.new }

    it "answers zero errors when valid BMP" do
      path = SPEC_ROOT.join "support/fixtures/test.bmp"
      attacher.assign path.open

      expect(attacher.errors).to eq([])
    end

    it "answers zero errors when valid PNG" do
      path = SPEC_ROOT.join "support/fixtures/test.png"
      attacher.assign path.open

      expect(attacher.errors).to eq([])
    end

    it "answers errors when invalid" do
      attacher.assign StringIO.new([123].pack("N"))

      expect(attacher.errors).to eq(
        [
          "type must be one of: image/bmp, image/png",
          "extension must be one of: bmp, png"
        ]
      )
    end
  end
end
