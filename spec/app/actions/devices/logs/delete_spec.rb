# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Devices::Logs::Delete, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:device_log) { Factory[:device_log] }

    it "answers success with valid parameters" do
      device_log
      response = action.call device_id: device_log.device_id, id: device_log.id

      expect(response).to have_attributes(status: 200, body: [""])
    end

    it "answers unprocessable entity with invalid ID" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
