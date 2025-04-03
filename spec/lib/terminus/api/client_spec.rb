# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::API::Client do
  using Refinements::Hash

  subject(:client) { described_class.new settings: Terminus::API::Configuration.new, http: }

  describe "#get" do
    include_context "with fake HTTP current screen"

    it "answers success response" do
      response = client.get "current_screen", api_key: "secret"
      payload = response.fmap(&:parse).bind(&:symbolize_keys!)

      expect(payload).to eq(
        status: 200,
        refresh_rate: 3200,
        image_url: "https://test.io/images/test.bmp",
        filename: "test.bmp",
        rendered_at: nil
      )
    end

    context "with failure" do
      let :http do
        HTTP::Fake::Client.new do
          get "/api/current_screen" do
            headers["Content-Type"] = "application/json"
            status 404

            <<~JSON
              {
                "message": "Danger!"
              }
            JSON
          end
        end
      end

      it "answers failure response" do
        response = client.get "current_screen"
        payload = response.alt_map { |result| result.parse.symbolize_keys! }

        expect(payload).to be_failure(message: "Danger!")
      end
    end
  end
end
