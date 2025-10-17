# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Designer::EventStream, :db do
  subject(:event_stream) { described_class.new screen.name, kernel: }

  include_context "with application dependencies"

  let(:screen) { Factory[:screen, :with_image] }
  let(:kernel) { class_spy Kernel }
  let(:at) { Time.now.to_i }

  before { allow(kernel).to receive(:loop).and_yield }

  describe "#each" do
    it "answers image when screen is found" do
      payload = nil
      event_stream.each { payload = it }

      expect(payload).to eq(<<~CONTENT)
        event: preview
        data: <img src="memory://abc123.png" alt="Preview" class="image" width="1" height="1"/>

      CONTENT
    end

    it "logs debug message when screen is found" do
      event_stream.each { it == :ignore }
      expect(logger.reread).to match(%r(DEBUG.+Streaming.+/abc123.png\.))
    end

    it "answers loader image when screen doesn't exist" do
      event_stream = described_class.new("bogus", kernel:)

      payload = nil
      event_stream.each { payload = it }

      expect(payload).to eq(<<~CONTENT)
        event: preview
        data: <img src="#{Hanami.app[:assets]["loader.svg"]}" alt="Loader" class="image" width="800" height="480"/>

      CONTENT
    end

    it "logs debug message when screen doesn't exist" do
      event_stream = described_class.new("bogus", kernel:)
      event_stream.each { it == :ignore }

      expect(logger.reread).to match(%r(DEBUG.+/assets/loader.*\.svg\.))
    end

    it "sleeps for one second" do
      event_stream.each(&:to_s)
      expect(kernel).to have_received(:sleep).with(1)
    end
  end
end
