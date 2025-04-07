# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Endpoints::Display::Requester do
  subject(:requester) { described_class.new client: }

  include_context "with library dependencies"
  include_context "with fake HTTP display"

  let(:client) { Terminus::API::Client.new http: }

  describe "#call" do
    it "answers success" do
      response = requester.call api_key: "secret"
      expect(response).to be_success(
        Terminus::Endpoints::Display::Response[
          filename: "test.bmp",
          firmware_url: "https://test.io/FW1.4.8.bin",
          image_url: "https://test.io/images/test.bmp",
          refresh_rate: 3200,
          reset_firmware: false,
          special_function: "restart_playlist",
          update_firmware: true
        ]
      )
    end

    context "with failure" do
      let :http do
        HTTP::Fake::Client.new do
          get "/api/display" do
            headers["Content-Type"] = "application/json"
            status 404

            <<~JSON
              {"error": "Danger!"}
            JSON
          end
        end
      end

      it "answers failure response" do
        response = described_class.new(client:).call api_key: "secret"
        expect(response).to match(Failure(be_a(HTTP::Response)))
      end
    end
  end
end
