# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Downloader do
  using Refinements::Pathname

  subject(:downloader) { described_class.new settings:, client: }

  include_context "with main application"

  let :client do
    fixture_path.copy image_path
    instance_double Terminus::Downloader, call: Success(image_path)
  end

  let(:fixture_path) { SPEC_ROOT.join "support/fixtures/test.png" }
  let(:image_path) { temp_dir.join "test.png" }

  describe "#call" do
    it "downloads file" do
      expect(downloader.call("https://test.io/test.png", "test.png")).to be_success(image_path)
    end

    it "applies correct file extension" do
      expect(downloader.call("https://test.io/test.png", "test")).to be_success(image_path)
    end

    it "marks downloaded file older than oldest file" do
      temp_dir.join("test.txt").write("test").touch Time.new(2000, 1, 1, 0, 0, 0)
      downloader.call "https://test.io/test.png", "test.png"

      expect(temp_dir.join("test.png").mtime.year).to eq(1999)
    end

    context "when unable to download" do
      let(:client) { instance_double Terminus::Downloader, call: Failure("Danger!") }

      it "answers failure" do
        expect(downloader.call("https://test.io/test.png", "test")).to be_failure("Danger!")
      end
    end

    context "with invalid download" do
      let :client do
        image_path.touch
        instance_double Terminus::Downloader, call: Success(image_path)
      end

      it "answers failure" do
        result = downloader.call "https://test.io/test.png", "test.png"
        expect(result).to be_failure(%(Unable to analyze image: #{temp_dir.join "test.png"}.))
      end
    end
  end
end
