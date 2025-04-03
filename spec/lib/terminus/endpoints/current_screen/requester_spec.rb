# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Endpoints::CurrentScreen::Requester do
  subject(:requester) { described_class.new client: }

  let(:client) { Terminus::API::Client.new http: }

  describe "#call" do
    include_context "with fake HTTP current screen"

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

    it "answers failure when attributes are missing" do
      response = described_class.new.call api_key: "secret"
      expect(response).to match(Failure(be_a(HTTP::Response)))
    end
  end
end
