# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Fetcher, :db do
  using Refinements::Pathname

  subject(:fetcher) { described_class.new settings: }

  include_context "with main application"

  describe "#call" do
    let(:device) { Factory[:device] }
    let(:fixture_path) { SPEC_ROOT.join "support/fixtures/test.bmp" }
    let(:asset_path) { temp_dir.join(device.slug).mkpath.join "test.bmp" }

    it "answers default image" do
      expect(fetcher.call(device)).to match(
        filename: "empty_state",
        image_url: %r(/assets/setup.+svg)
      )
    end

    it "answers generated image without encryption" do
      fixture_path.copy asset_path

      expect(fetcher.call(device)).to eq(
        filename: "test.bmp",
        image_url: "https://localhost/assets/screens/A1B2C3D4E5F6/test.bmp"
      )
    end

    it "answers generated image with encryption" do
      fixture_path.copy asset_path

      expect(fetcher.call(device, encryption: :base_64)).to match(
        filename: "test.bmp",
        image_url: %r(data:image/bmp;base64,.+)
      )
    end

    it "answers generated image without encryption when given invalid encryption" do
      fixture_path.copy asset_path

      expect(fetcher.call(device, encryption: :bogus)).to eq(
        filename: "test.bmp",
        image_url: "https://localhost/assets/screens/A1B2C3D4E5F6/test.bmp"
      )
    end
  end
end
