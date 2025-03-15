# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Devices::Update, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:device) { Factory[:device] }

    it "answers success when there are no validation errors" do
      device
      response = action.call id: device.id, device: {label: "Test"}
      expect(response.status).to eq(200)
    end

    it "answers errors when fields are missing" do
      response = action.call id: device.id, device: {label: ""}
      expect(response.body.to_s).to include("must be filled")
    end

    it "answers unprocessable entity for unknown device" do
      response = action.call id: 99
      expect(response.status).to eq(422)
    end
  end
end
