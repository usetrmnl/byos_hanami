# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Uploaders::Binary do
  subject(:uploader) { described_class }

  include_context "with temporary directory"

  describe "#call" do
    let(:attacher) { uploader::Attacher.new }

    it "answers zero errors when valid" do
      path = temp_dir.join "test.bin"
      path.binwrite [123].pack("N")
      attacher.assign path.open

      expect(attacher.errors).to eq([])
    end

    it "answers errors when invalid" do
      attacher.assign SPEC_ROOT.join("support/fixtures/test.png").open

      expect(attacher.errors).to eq(
        [
          "type must be one of: application/octet-stream",
          "extension must be one of: bin"
        ]
      )
    end
  end
end
