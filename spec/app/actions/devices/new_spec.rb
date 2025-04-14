# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Devices::New do
  subject(:action) { described_class.new }

  describe "#call" do
    it "renders htmx response" do
      device = {mac_address: "aa:bb:cc:11:22:33"}

      response = Rack::MockRequest.new(action)
                                  .post "", "HTTP_HX_REQUEST" => "true", params: {device:}

      expect(response.body).not_to include("<!DOCTYPE html>")
    end
  end
end
