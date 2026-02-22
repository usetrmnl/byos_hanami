# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Models::Finder, :db do
  subject(:finder) { described_class.new }

  using Refinements::Hash

  describe "#call" do
    let(:model) { Factory[:model, name: "test"] }
    let(:device) { Factory[:device, model_id: model.id] }

    it "answers success when found by model ID" do
      expect(finder.call(model_id: model.id)).to be_success(model)
    end

    it "answers success when found by device ID" do
      expect(finder.call(device_id: device.id)).to be_success(model)
    end

    it "answers failure when unable to find by model or device ID" do
      expect(finder.call(model_id: 13, device_id: 666)).to be_failure(
        "Unable to find model for model ID (13) or device ID (666)."
      )
    end
  end
end
