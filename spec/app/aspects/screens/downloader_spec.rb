# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Downloader do
  using Refinements::Pathname

  subject(:downloader) { described_class.new client: }

  include_context "with temporary directory"

  let(:client) { HTTP }
  let(:settings) { Hanami.app[:settings] }

  describe "#call" do
    before { allow(settings).to receive(:screens_root).and_return temp_dir }

    it "downloads file" do
      downloader.call "https://usetrmnl.com/assets/mashups.png", "test.png"
      expect(temp_dir.join("test.png").exist?).to be(true)
    end

    it "marks downloaded file older than oldest file" do
      temp_dir.join("test.txt").write("test").touch Time.new(2000, 1, 1, 0, 0, 0)
      downloader.call "https://usetrmnl.com/assets/mashups.png", "test.png"

      expect(temp_dir.join("test.png").mtime.year).to eq(1999)
    end

    it "answers output path" do
      result = downloader.call "https://usetrmnl.com/assets/mashups.png", "test.png"

      expect(result).to be_success(temp_dir.join("test.png"))
    end

    it "answers failure when image can't be downloaded" do
      code = downloader.call("https://test.io/bogus.png", "bogus.png").alt_map { it.status.code }
      expect(code).to be_failure(404)
    end
  end
end
