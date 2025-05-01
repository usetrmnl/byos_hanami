# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Firmware::Fetcher do
  using Refinements::Pathname

  subject(:fetcher) { described_class.new settings:, public_root: temp_dir }

  include_context "with main application"

  describe "#call" do
    it "answers records in descending order" do
      temp_dir.join("1.0.0.bin").write("For size test.")
      temp_dir.join("1.0.1.bin").touch

      expect(fetcher.call).to eq(
        [
          Terminus::Aspects::Firmware::Model[
            path: Pathname("1.0.1.bin"),
            size: 0,
            uri: "https://localhost/1.0.1.bin",
            version: "1.0.1"
          ],
          Terminus::Aspects::Firmware::Model[
            path: Pathname("1.0.0.bin"),
            size: 14,
            uri: "https://localhost/1.0.0.bin",
            version: "1.0.0"
          ]
        ]
      )
    end

    it "answers empty array when there are no files" do
      expect(fetcher.call).to eq([])
    end
  end
end
