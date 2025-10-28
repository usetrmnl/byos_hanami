# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Renderer do
  subject(:renderer) { described_class.new }

  describe "#call" do
    let(:extension) { Factory.structs[:extension] }

    context "with image kind" do
      subject(:renderer) { described_class.new image: }

      let(:image) { instance_spy Terminus::Aspects::Extensions::Renderers::Image }

      it "delegates to image renderer" do
        allow(extension).to receive(:kind).and_return("image")
        renderer.call extension

        expect(image).to have_received(:call).with(extension)
      end
    end

    context "with poll kind" do
      subject(:renderer) { described_class.new poll: }

      let(:poll) { instance_spy Terminus::Aspects::Extensions::Renderers::Poll }

      it "delegates to poll renderer" do
        renderer.call extension
        expect(poll).to have_received(:call).with(extension)
      end
    end

    context "with static kind" do
      subject(:renderer) { described_class.new static: }

      let(:static) { instance_spy Terminus::Aspects::Extensions::Renderers::Static }

      it "delegates to static renderer" do
        allow(extension).to receive(:kind).and_return("static")
        renderer.call extension

        expect(static).to have_received(:call).with(extension)
      end
    end

    context "with unknown kind" do
      it "answers failure" do
        allow(extension).to receive(:kind).and_return("bogus")
        renderer.call extension

        expect(renderer.call(extension)).to be_failure("Unsupported extension kind: bogus.")
      end
    end
  end
end
