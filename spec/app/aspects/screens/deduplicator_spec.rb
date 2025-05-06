# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Deduplicator do
  using Refinements::Pathname

  subject(:deduplicator) { described_class.new }

  include_context "with main application"

  describe "#call" do
    let(:download_path) { temp_dir.join "download.png" }
    let(:current_path) { temp_dir.join "current.png" }

    before do
      fixture_path = SPEC_ROOT.join "support/fixtures/test.png"

      fixture_path.copy download_path
      fixture_path.copy current_path
    end

    it "deletes download path with images are identical" do
      deduplicator.call download_path, current_path
      expect(temp_dir.files).to contain_exactly(current_path)
    end

    context "when not identical" do
      before { MiniMagick::Image.new(download_path).resize "5x5" }

      it "updates current with download content" do
        deduplicator.call download_path, current_path
        expect(MiniMagick::Image.new(current_path).dimensions).to eq([5, 5])
      end

      it "deletes download" do
        deduplicator.call download_path, current_path
        expect(temp_dir.files).to contain_exactly(current_path)
      end

      it "marks current path as older" do
        temp_dir.join("old.txt").write("test").touch Time.new(2000, 1, 1, 0, 0, 0)
        deduplicator.call download_path, current_path

        expect(current_path.mtime.year).to eq(1999)
      end
    end

    context "when current path doesn't exist" do
      before { current_path.delete }

      it "renames download as current when current doesn't exist" do
        deduplicator.call download_path, current_path
        expect(temp_dir.files).to contain_exactly(current_path)
      end

      it "marks current path as older" do
        temp_dir.join("old.txt").write("test").touch Time.new(2000, 1, 1, 0, 0, 0)
        deduplicator.call download_path, current_path

        expect(current_path.mtime.year).to eq(1999)
      end
    end

    it "answers current path" do
      expect(deduplicator.call(download_path, current_path)).to be_success(current_path)
    end

    it "answers failure when image can't be processed" do
      result = deduplicator.call temp_dir.join("bogus.bmp"), current_path
      expect(result).to be_failure("Unable to analyze images for deduplication.")
    end
  end
end
