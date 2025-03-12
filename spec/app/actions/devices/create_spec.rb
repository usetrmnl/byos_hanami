# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Devices::Create, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:device) { Factory[:device] }

    it "answers success with valid parameters" do
      response = action.call device: {
        label: "Test",
        friendly_id: "TEST",
        mac_address: "aa:bb:cc:11:22:33",
        api_key: "abc123",
        refresh_rate: 123
      }

      expect(response.status).to eq(200)
    end

    it "answers errors with invalid parameters" do
      response = action.call device: {}
      expect(response.body.to_s).to include("is missing")
    end
  end
end
