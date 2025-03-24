# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::API::Setup::Show, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:device) { Factory[:device] }
    let(:repository) { Terminus::Repositories::Device.new }

    context "with no devices" do
      let(:mac_address) { "aa:bb:cc:00:11:22" }
      let(:response) { Rack::MockRequest.new(action).get "/api/setup", "HTTP_ID" => mac_address }
      let(:payload) { JSON response.body, symbolize_names: true }
      let(:device) { repository.find_by_mac_address mac_address }

      it "registers new device for MAC address" do
        expect(payload).to eq(
          api_key: device.api_key,
          friendly_id: device.friendly_id,
          image_url: %(#{Hanami.app[:settings].api_uri}/assets/setup.bmp),
          message: "Welcome to TRMNL BYOS."
        )
      end

      it "creates device with generated defaults" do
        response

        expect(device).to have_attributes(
          label: "TRMNL",
          friendly_id: /[A-Z0-9]{6}/,
          mac_address:,
          api_key: /[a-z0-9]{20}/i,
          setup_at: instance_of(Time)
        )
      end
    end

    it "answers existing device for MAC address" do
      response = Rack::MockRequest.new(action).get "/api/setup", "HTTP_ID" => device.mac_address
      payload = JSON response.body, symbolize_names: true

      expect(payload).to eq(
        api_key: device.api_key,
        friendly_id: device.friendly_id,
        image_url: %(#{Hanami.app[:settings].api_uri}/assets/setup.bmp),
        message: "Welcome to TRMNL BYOS."
      )
    end
  end
end
