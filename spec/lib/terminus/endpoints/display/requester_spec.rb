# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Endpoints::Display::Requester do
  subject(:requester) { described_class.new client: }

  let(:client) { Terminus::API::Client.new http: }

  describe "#call" do
    include_context "with fake HTTP display"

    it "answers success" do
      response = requester.call access_token: "secret"
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

    it "answers failure when attributes are missing" do
      response = described_class.new.call access_token: "secret"

      expect(response).to be_failure(
        Terminus::Endpoints::Display::Contract.call({reset_firmware: true})
      )
    end
  end
end
