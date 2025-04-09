# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Rotator do
  using Refinements::Pathname

  subject(:rotator) { described_class.new settings: }

  include_context "with temporary directory"

  let(:settings) { Hanami.app[:settings] }

  before do
    allow(settings).to receive_messages screens_root: temp_dir, api_uri: "https://localhost"
  end

  describe "#call" do
    before do
      temp_dir.join("abc/one.bmp").make_ancestors.touch
      temp_dir.join("abc/two.bmp").make_ancestors.touch
    end

    it "answers oldest image" do
      skip "Doesn't work on CI." if ENV["CI"]

      expect(rotator.call("abc")).to eq(
        filename: "two.bmp",
        image_url: "https://localhost/assets/screens/abc/two.bmp"
      )
    end

    it "answers oldest image with encryption" do
      skip "Doesn't work on CI." if ENV["CI"]

      expect(rotator.call("abc", encryption: :base_64)).to eq(
        filename: "two.bmp",
        image_url: "data:image/bmp;base64,"
      )
    end

    it "updates oldest image as newest image" do
      rotator.call "abc"

      expect(temp_dir.join("abc").files.sort_by(&:mtime)).to eq(
        [
          temp_dir.join("abc/two.bmp"),
          temp_dir.join("abc/one.bmp")
        ]
      )
    end
  end
end
