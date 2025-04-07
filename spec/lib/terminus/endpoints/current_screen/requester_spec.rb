# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Endpoints::CurrentScreen::Requester do
  subject(:requester) { described_class.new client: }

  include_context "with library dependencies"
  include_context "with fake HTTP current screen"

  let(:client) { Terminus::API::Client.new http: }

  describe "#call" do
    it "answers success" do
      response = requester.call api_key: "secret"

      expect(response).to be_success(
        Terminus::Endpoints::CurrentScreen::Response[
          refresh_rate: 3200,
          image_url: "https://test.io/images/test.bmp",
          filename: "test.bmp"
        ]
      )
    end

    context "with failure" do
      let :http do
        HTTP::Fake::Client.new do
          get "/api/current_screen" do
            headers["Content-Type"] = "application/json"
            status 404

            <<~JSON
              {"error": "Danger!"}
            JSON
          end
        end
      end

      it "answers error response" do
        response = described_class.new(client:).call api_key: "secret"
        expect(response).to match(Failure(be_a(HTTP::Response)))
      end
    end
  end
end
