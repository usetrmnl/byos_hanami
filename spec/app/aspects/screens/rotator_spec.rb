# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Rotator, :db do
  using Refinements::Pathname

  subject(:rotator) { described_class.new settings: }

  include_context "with main application"

  describe "#call" do
    let(:device) { Factory[:device] }

    before do
      temp_dir.join("#{device.slug}/one.bmp").make_ancestors.touch
      temp_dir.join("#{device.slug}/two.bmp").make_ancestors.touch
    end

    it "answers oldest image" do
      skip "Doesn't work on CI." if ENV["CI"]

      expect(rotator.call(device)).to eq(
        filename: "two.bmp",
        image_url: "https://localhost/assets/screens/A1B2C3D4E5F6/two.bmp"
      )
    end

    it "answers oldest image with encryption" do
      skip "Doesn't work on CI." if ENV["CI"]

      expect(rotator.call(device, encryption: :base_64)).to eq(
        filename: "two.bmp",
        image_url: "data:image/bmp;base64,"
      )
    end

    it "updates oldest image as newest image" do
      rotator.call device

      expect(temp_dir.join("A1B2C3D4E5F6").files.sort_by(&:mtime)).to eq(
        [
          temp_dir.join("A1B2C3D4E5F6/two.bmp"),
          temp_dir.join("A1B2C3D4E5F6/one.bmp")
        ]
      )
    end
  end
end
