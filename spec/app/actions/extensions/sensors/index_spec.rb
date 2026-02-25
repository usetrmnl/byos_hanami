# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Extensions::Sensors::Index, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:extension) { Factory[:extension] }
    let(:repository) { Terminus::Repositories::Extension.new }

    let :response do
      action.call Rack::MockRequest.env_for(
        extension.id.to_s,
        "router.params" => {extension_id: extension.id}
      )
    end

    context "with sensor data" do
      let(:sensor_one) { Factory[:device_sensor, make: "ACME I"] }
      let(:sensor_two) { Factory[:device_sensor, make: "ACME II"] }

      before do
        repository.update_with_devices extension.id,
                                       {},
                                       [sensor_one.device_id, sensor_two.device_id]
      end

      it "renders data" do
        expect(response.body.first).to match(/textarea.+sensors.+make.+ACME I.+make.+ACME II/m)
      end
    end

    context "without sensor data" do
      it "renders empty data" do
        expect(response.body.first).to match(/textarea.+sensors.+\[\]/m)
      end
    end

    it "answers not found error with invalid ID" do
      response = action.call Hash.new
      expect(response.status).to eq(404)
    end
  end
end
