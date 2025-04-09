# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Fetcher do
  using Refinements::Pathname

  subject(:fetcher) { described_class.new settings: }

  include_context "with temporary directory"

  let(:settings) { Hanami.app[:settings] }

  before { allow(settings).to receive_messages screens_root: temp_dir, api_uri: "https://localhost" }

  describe "#call" do
    let(:fixture_path) { SPEC_ROOT.join "support/fixtures/test.bmp" }
    let(:asset_path) { temp_dir.join(slug).mkpath.join "test.bmp" }
    let(:slug) { "abc" }

    it "answers default image" do
      expect(fetcher.call(slug)).to match(
        filename: "empty_state",
        image_url: "https://localhost/assets/setup.bmp"
      )
    end

    it "answers generated image without encryption" do
      fixture_path.copy asset_path

      expect(fetcher.call(slug)).to eq(
        filename: "test.bmp",
        image_url: "https://localhost/assets/screens/abc/test.bmp"
      )
    end

    it "answers generated image with encryption" do
      fixture_path.copy asset_path

      expect(fetcher.call(slug, encryption: :base_64)).to match(
        filename: "test.bmp",
        image_url: %r(data:image/bmp;base64,.+)
      )
    end

    it "answers generated image without encryption when given invalid encryption" do
      fixture_path.copy asset_path

      expect(fetcher.call(slug, encryption: :bogus)).to eq(
        filename: "test.bmp",
        image_url: "https://localhost/assets/screens/abc/test.bmp"
      )
    end
  end
end
