# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Savers::Payload, :db do
  subject(:payload) { described_class[model:, label: "Test", name: "test", content: "test"] }

  let(:model) { Factory[:model, id: 1] }

  describe "#attributes" do
    it "answers record only attributes" do
      expect(payload.attributes).to eq(model_id: 1, label: "Test", name: "test")
    end
  end

  describe "#filename" do
    it "answers filename" do
      expect(payload.filename).to eq("test.png")
    end

    it "answers nil when model is missing" do
      expect(payload.with(model: nil).filename).to be(nil)
    end
  end
end
