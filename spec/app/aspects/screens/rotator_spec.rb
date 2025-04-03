# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Rotator do
  using Refinements::Pathname

  subject(:rotator) { described_class.new settings: }

  include_context "with temporary directory"

  let(:settings) { Hanami.app[:settings] }

  before { allow(settings).to receive(:generated_root).and_return temp_dir }

  describe "#call" do
    let(:images_uri) { "https://test.io/images" }

    it "answers oldest image" do
      skip "Doesn't work on CI." if ENV["CI"]

      temp_dir.join("one.bmp").touch
      temp_dir.join("two.bmp").touch

      expect(rotator.call(images_uri:)).to eq(
        filename: "two.bmp",
        image_url: "https://test.io/images/generated/two.bmp"
      )
    end

    it "answers oldest image with encryption" do
      skip "Doesn't work on CI." if ENV["CI"]

      temp_dir.join("one.bmp").touch
      temp_dir.join("two.bmp").touch

      expect(rotator.call(images_uri:, encryption: :base_64)).to eq(
        filename: "two.bmp",
        image_url: "data:image/bmp;base64,"
      )
    end

    it "updates oldest image as newest image" do
      temp_dir.join("one.bmp").touch
      temp_dir.join("two.bmp").touch

      rotator.call(images_uri:)

      expect(temp_dir.files.sort_by(&:mtime)).to eq(
        [
          temp_dir.join("two.bmp"),
          temp_dir.join("one.bmp")
        ]
      )
    end
  end
end
