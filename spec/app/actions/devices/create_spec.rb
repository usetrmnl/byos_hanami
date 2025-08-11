# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Devices::Create, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:model) { Factory[:model] }

    let :params do
      {
        device: {
          model_id: model.id,
          playlist_id: nil,
          label: "Test",
          friendly_id: "ABC123",
          mac_address: "AA:BB:CC:11:22:33",
          api_key: "abc",
          refresh_rate: 100,
          image_timeout: 100
        }
      }
    end

    it "renders default response" do
      response = Rack::MockRequest.new(action).post("", params:)
      expect(response.body).to include("<!DOCTYPE html>")
    end

    it "renders htmx response" do
      response = Rack::MockRequest.new(action).post("", "HTTP_HX_REQUEST" => "true", params:)
      expect(response.body).to have_htmx_title("Devices")
    end
  end
end
