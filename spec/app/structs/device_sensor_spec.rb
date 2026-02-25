# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::DeviceSensor do
  subject(:sensor) { Factory.structs[:device_sensor] }

  describe "#liquid_attributes" do
    it "answers attributes" do
      expect(sensor.liquid_attributes).to eq(
        "device_id" => nil,
        "kind" => "temperature",
        "make" => "ACME",
        "model" => "Test",
        "value" => 20.1,
        "unit" => "celcius",
        "source" => "device",
        "created_at" => Time.new(2025, 1, 1).utc
      )
    end
  end
end
