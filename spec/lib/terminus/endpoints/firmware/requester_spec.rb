# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Endpoints::Firmware::Requester do
  subject(:requester) { described_class.new client: }

  include_context "with library dependencies"

  let(:client) { Terminus::API::Client.new http: }

  describe "#call" do
    let :http do
      HTTP::Fake::Client.new do
        get "/api/firmware/latest" do
          headers["Content-Type"] = "application/json"
          status 200

          <<~JSON
            {
              "url": "https://test.io/FW1.2.3.bin",
              "version": "1.2.3"
            }
          JSON
        end
      end
    end

    it "answers success" do
      response = requester.call

      expect(response).to be_success(
        Terminus::Endpoints::Firmware::Response[
          url: "https://test.io/FW1.2.3.bin",
          version: "1.2.3"
        ]
      )
    end

    context "with failure" do
      let :http do
        HTTP::Fake::Client.new do
          get "/api/firmware/latest" do
            headers["Content-Type"] = "application/json"
            status 404

            <<~JSON
              {"error": "Danger!"}
            JSON
          end
        end
      end

      it "answers failure response" do
        response = described_class.new(client:).call
        expect(response).to match(Failure(be_a(HTTP::Response)))
      end
    end
  end
end
