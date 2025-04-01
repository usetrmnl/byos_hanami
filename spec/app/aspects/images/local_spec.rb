# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Images::Local do
  using Refinements::Pathname

  subject(:fetcher) { described_class.new settings: }

  include_context "with temporary directory"

  let(:settings) { Hanami.app[:settings] }

  before { allow(settings).to receive(:generated_root).and_return temp_dir }

  describe "#call" do
    let(:fixture_path) { SPEC_ROOT.join "support/fixtures/test.bmp" }
    let(:images_uri) { "https://localhost/assets" }

    it "answers default image" do
      expect(fetcher.call(images_uri:)).to match(
        filename: "empty_state",
        image_url: %r(/assets/setup.*\.bmp)
      )
    end

    it "answers generated image without encryption" do
      path = temp_dir.join "test.bmp"
      fixture_path.copy path

      expect(fetcher.call(images_uri:)).to eq(
        filename: "test.bmp",
        image_url: "https://localhost/assets/generated/test.bmp"
      )
    end

    it "answers generated image with encryption" do
      path = temp_dir.join "test.bmp"
      fixture_path.copy path

      expect(fetcher.call(images_uri:, encryption: :base_64)).to match(
        filename: "test.bmp",
        image_url: %r(data:image/bmp;base64,.+)
      )
    end

    it "answers generated image without encryption when given invalid encryption" do
      path = temp_dir.join "test.bmp"
      fixture_path.copy path

      expect(fetcher.call(images_uri:, encryption: :bogus)).to eq(
        filename: "test.bmp",
        image_url: "https://localhost/assets/generated/test.bmp"
      )
    end
  end
end
