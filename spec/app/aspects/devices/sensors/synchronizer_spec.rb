# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Devices::Sensors::Synchronizer, :db do
  using Refinements::Pathname

  subject(:synchronizer) { described_class.new }

  include_context "with application dependencies"

  let(:repository) { Terminus::Repositories::DeviceSensor.new }
  let(:path) { SPEC_ROOT.join "support/fixtures/sensors.json" }

  before { allow(settings).to receive(:sensors_path).and_return(path) }

  describe "#call" do
    it "creates sensor records when they don't exist" do
      device = Factory[:device]
      synchronizer.call

      expect(repository.all).to match(
        array_including(
          having_attributes(
            device_id: device.id,
            make: "Sensirion",
            model: "SCD41",
            kind: "carbon_dioxide",
            source: "server",
            created_at: Time.at(1735714800)
          ),
          having_attributes(
            device_id: device.id,
            make: "Sensirion",
            model: "SCD41",
            kind: "temperature",
            source: "server",
            created_at: Time.at(1735714800)
          ),
          having_attributes(
            device_id: device.id,
            make: "Sensirion",
            model: "SCD41",
            kind: "humidity",
            source: "server",
            created_at: Time.at(1735714800)
          )
        )
      )
    end

    context "with duplicate sensors" do
      let(:sensor) { Factory[:device_sensor] }

      let :data do
        {
          data: [
            {
              make: sensor.make,
              model: sensor.model,
              kind: sensor.kind,
              value: sensor.value,
              unit: sensor.unit,
              created_at: sensor.created_at.to_i
            }
          ]
        }
      end

      before do
        path = temp_dir.join("sensors.json").write(data.to_json)
        allow(settings).to receive(:sensors_path).and_return(path)
      end

      it "logs duplicate" do
        synchronizer.call

        expect(logger.reread).to match(
          /DEBUG.+Duplicate sensor detected. Skipped\..+make.+model.+kind.+value.+unit.+created_at/
        )
      end

      it "skips sensor creation" do
        expectation = proc { synchronizer.call }
        count = proc { repository.all.size }

        expect(&expectation).not_to change(&count)
      end
    end

    context "with missing sensors path" do
      let(:path) { temp_dir.join "sensors.json" }

      it "doesn't upsert with devices" do
        Factory[:device]
        expectation = proc { synchronizer.call }
        count = proc { repository.all.size }

        expect(&expectation).not_to change(&count)
      end

      it "doesn't upsert without devices" do
        expectation = proc { synchronizer.call }
        count = proc { repository.all.size }

        expect(&expectation).not_to change(&count)
      end

      it "logs synchronization was skipped" do
        synchronizer.call
        expect(logger.reread).to match(/DEBUG.+Sensors path not found: #{path}. Skipped./)
      end
    end

    context "with invalid sensor attributes" do
      let(:path) { temp_dir.join "sensors.json" }

      before do
        Factory[:device]

        path.write <<~JSON
          {
            "data": [
              {
                "make": "Sensirion",
                "model": "SCD41",
                "kind": "co2",
                "created_at": 1771339473
              }
            ]
          }
        JSON
      end

      it "doesn't upsert" do
        expectation = proc { synchronizer.call }
        count = proc { repository.all.size }

        expect(&expectation).not_to change(&count)
      end

      it "logs synchronization was skipped" do
        synchronizer.call

        expect(logger.reread).to match(
          /ERROR.+Unable to validate sensor: value is missing and unit is missing\./
        )
      end
    end
  end
end
