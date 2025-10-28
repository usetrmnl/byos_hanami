# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Renderer, :db do
  subject(:renderer) { described_class.new }

  using Refinements::Hash

  describe "#call" do
    let(:extension) { Factory.structs[:extension, data: {}] }
    let(:model) { Factory[:model] }

    let :context do
      {
        "extension" => {},
        "model" => model.liquid_attributes.stringify_keys!
      }
    end

    context "with image kind" do
      subject(:renderer) { described_class.new image: }

      let(:image) { instance_spy Terminus::Aspects::Extensions::Renderers::Image }

      it "delegates to image renderer" do
        allow(extension).to receive(:kind).and_return("image")
        renderer.call extension, model.id

        expect(image).to have_received(:call).with(extension, context:)
      end
    end

    context "with poll kind" do
      subject(:renderer) { described_class.new poll: }

      let(:poll) { instance_spy Terminus::Aspects::Extensions::Renderers::Poll }

      it "delegates to poll renderer" do
        renderer.call extension, model.id
        expect(poll).to have_received(:call).with(extension, context:)
      end
    end

    context "with static kind" do
      subject(:renderer) { described_class.new static: }

      let(:static) { instance_spy Terminus::Aspects::Extensions::Renderers::Static }

      it "delegates to static renderer" do
        allow(extension).to receive(:kind).and_return("static")
        renderer.call extension, model.id

        expect(static).to have_received(:call).with(extension, context:)
      end
    end

    context "with unknown kind" do
      it "answers failure" do
        allow(extension).to receive(:kind).and_return("bogus")

        expect(renderer.call(extension, model.id)).to be_failure(
          "Unsupported extension kind: bogus."
        )
      end
    end
  end
end
