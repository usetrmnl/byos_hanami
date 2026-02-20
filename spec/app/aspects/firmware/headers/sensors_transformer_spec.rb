# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Firmware::Headers::SensorsTransformer do
  subject(:parser) { described_class.new }

  describe "#call" do
    let :content do
      "make=Sensirion;model=SCD41;kind=humidity;value=26;unit=percent;created_at=1735714800," \
      "make=Sensirion;model=SCD41;kind=temperature;value=20.10;unit=celcius;created_at=1735714800"
    end

    it "answers records hash" do
      expect(parser.call(content)).to eq(
        [
          {
            make: "Sensirion",
            model: "SCD41",
            kind: "humidity",
            value: "26",
            unit: "percent",
            source: "device",
            created_at: Time.at(1735714800)
          },
          {
            make: "Sensirion",
            model: "SCD41",
            kind: "temperature",
            value: "20.10",
            unit: "celcius",
            source: "device",
            created_at: Time.at(1735714800)
          }
        ]
      )
    end

    it "answers partial records with only single key and value" do
      expect(parser.call("make=Sensirion")).to eq([{make: "Sensirion", source: "device"}])
    end

    it "answers empty array when no key/value pairs exist" do
      expect(parser.call("make")).to eq([])
    end

    it "answers empty array when blank" do
      expect(parser.call("")).to eq([])
    end

    it "answers empty array when nil" do
      expect(parser.call(nil)).to eq([])
    end
  end
end
