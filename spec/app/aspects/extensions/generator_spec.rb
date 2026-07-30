# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Generator, :db do
  subject(:generator) { described_class.new }

  using Refinements::Hash

  describe "#call" do
    let(:extension) { Factory.structs[:extension, label: "Test", data: {}] }
    let(:model) { Factory[:model] }

    let :context do
      {
        "extension" => {
          "label" => "Test",
          "css_classes" => "screen screen--#{model.name} screen--1bit screen--landscape",
          "fields" => [],
          "values" => {},
          "data" => {}
        },
        "screen_variables" => "",
        "sensors" => []
      }
    end

    context "with image kind" do
      subject(:generator) { described_class.new image: }

      let(:image) { instance_spy Terminus::Aspects::Extensions::Generators::Image }

      it "delegates to generator" do
        allow(extension).to receive(:kind).and_return("image")
        generator.call extension, model_id: model.id

        expect(image).to have_received(:call).with(extension, context:)
      end
    end

    context "with poll kind" do
      subject(:generator) { described_class.new poll: }

      let(:poll) { instance_spy Terminus::Aspects::Extensions::Generators::Poll }

      it "delegates generator" do
        generator.call extension, model_id: model.id
        expect(poll).to have_received(:call).with(extension, context:)
      end
    end

    context "with static kind" do
      subject(:generator) { described_class.new static: }

      let(:static) { instance_spy Terminus::Aspects::Extensions::Generators::Static }

      it "delegates to generator" do
        allow(extension).to receive(:kind).and_return("static")
        generator.call extension, model_id: model.id

        expect(static).to have_received(:call).with(extension, context:)
      end
    end

    context "with unknown kind" do
      it "answers failure" do
        allow(extension).to receive(:kind).and_return("bogus")

        expect(generator.call(extension)).to be_failure("Unsupported extension kind: bogus.")
      end
    end
  end
end
