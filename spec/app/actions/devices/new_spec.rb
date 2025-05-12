# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Devices::New do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:params) { {device: {mac_address: "aa:bb:cc:11:22:33"}} }

    it "renders default response" do
      response = Rack::MockRequest.new(action).post("", params:)
      expect(response.body).to include("<!DOCTYPE html>")
    end

    it "renders htmx response" do
      response = Rack::MockRequest.new(action).post("", "HTTP_HX_REQUEST" => "true", params:)
      expect(response.body).not_to include("<!DOCTYPE html>")
    end
  end
end
