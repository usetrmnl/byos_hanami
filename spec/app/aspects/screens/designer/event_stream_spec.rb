# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Designer::EventStream, :db do
  subject(:event_stream) { described_class.new screen.name, kernel: }

  let(:screen) { Factory[:screen, :with_image] }
  let(:kernel) { class_spy Kernel }
  let(:at) { Time.now.to_i }

  before { allow(kernel).to receive(:loop).and_yield }

  describe "#each" do
    it "answers screen when found" do
      payload = nil
      event_stream.each(at:) { payload = it }

      expect(payload).to eq(<<~CONTENT)
        event: preview
        data: <img src="memory://abc123.png?#{at}" alt="Preview" class="image" width="1" height="1"/>

      CONTENT
    end

    it "falls back to loading image when screen doesn't exist" do
      event_stream = described_class.new("bogus", kernel:)

      payload = nil
      event_stream.each(at:) { payload = it }

      expect(payload).to eq(<<~CONTENT)
        event: preview
        data: <img src="/assets/loader.svg" alt="Loader" class="image" width="800" height="480"/>

      CONTENT
    end

    it "sleeps for one second" do
      event_stream.each(&:to_s)
      expect(kernel).to have_received(:sleep).with(1)
    end
  end
end
