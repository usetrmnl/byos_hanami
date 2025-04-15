# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Editor::EventStream do
  using Refinements::Pathname

  subject(:event_stream) { described_class.new "test", type: :png, kernel: }

  include_context "with main application"

  let(:kernel) { class_spy Kernel }

  describe "#each" do
    let(:image_path) { temp_dir.join "test.png" }

    before do
      allow(kernel).to receive(:loop).and_yield
      SPEC_ROOT.join("support/fixtures/test.png").copy image_path
    end

    it "answers rendered image when path matches" do
      payload = nil
      at = image_path.mtime.to_i

      event_stream.each { payload = it }

      expect(payload).to eq(<<~CONTENT)
        event: preview
        data: <img src="/assets/previews/test.png?#{at}" alt="Preview" class="image" width="1" height="1"/>

      CONTENT
    end

    it "falls back to loading image when path doesn't exist" do
      image_path.delete
      payload = nil
      event_stream.each { payload = it }

      expect(payload).to eq(<<~CONTENT)
        event: preview
        data: <img src="/assets/screen_preview.svg" alt="Loader" class="image" width="800" height="480"/>

      CONTENT
    end

    it "ensures image is always deleted" do
      event_stream.each(&:to_s)
      expect(image_path.exist?).to be(false)
    end

    it "sleeps for one second" do
      event_stream.each(&:to_s)
      expect(kernel).to have_received(:sleep).with(1)
    end
  end
end
