# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::API::Setup::Show, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:device) { Factory[:device] }

    it "answers registered device with valid ID" do
      response = Rack::MockRequest.new(action).get "/api/setup", "HTTP_ID" => device.mac_address
      payload = JSON response.body, symbolize_names: true

      expect(payload).to eq(
        status: 200,
        api_key: "abc123",
        friendly_id: "ABC123",
        image_url: %(#{Hanami.app[:settings].api_uri}/images/setup/logo.bmp),
        message: "Welcome to TRMNL BYOS"
      )
    end

    it "answers device that couldn't be registered with invalid ID" do
      response = Rack::MockRequest.new(action).get "/api/setup", "HTTP_ID" => "bogus"
      payload = JSON response.body, symbolize_names: true

      expect(payload).to eq(
        status: 404,
        api_key: nil,
        friendly_id: nil,
        image_url: nil,
        message: "MAC Address not registered."
      )
    end

    it "answers not found for no MAC address" do
      response = action.call Hash.new
      expect(response.status).to eq(404)
    end
  end
end
