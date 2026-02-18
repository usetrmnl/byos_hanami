# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Contextualizer, :db do
  subject(:contextualizer) { described_class.new }

  using Refinements::Hash

  describe "#call" do
    let(:extension) { Factory.structs[:extension, fields: [{"keyname" => "one", "default" => 1}]] }
    let(:model) { Factory[:model, name: "test"] }
    let(:device) { Factory[:device, model_id: model.id] }
    let(:sensor) { Factory[:device_sensor, device_id: device.id] }

    it "answers all attributes" do
      sensor

      expect(contextualizer.call(extension, model_id: model.id, device_id: device.id)).to eq(
        "extension" => {
          "fields" => [{"keyname" => "one", "default" => 1}],
          "values" => {"one" => 1}
        },
        "model" => {"bit_depth" => 1, "name" => "test", "orientation" => "landscape"},
        "sensors" => [
          {
            "kind" => "temperature",
            "make" => "ACME",
            "model" => "Test",
            "unit" => "celcius",
            "value" => 20.1,
            "source" => "device",
            "created_at" => Time.new(2025, 1, 1).utc
          }
        ]
      )
    end

    it "answers attributes without fields, values, model, and sensors" do
      extension = Factory.structs[:extension]

      expect(contextualizer.call(extension)).to eq(
        "extension" => {"fields" => [], "values" => {}},
        "model" => nil,
        "sensors" => []
      )
    end
  end
end
