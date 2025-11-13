# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::API::Log::Create, :db do
  subject(:action) { described_class.new logger: }

  let(:device) { Factory[:device] }
  let(:logger) { instance_spy Dry::Logger::Dispatcher }

  describe "#call" do
    let :headers do
      {
        "HTTP_BASE64" => "true",
        "HTTP_FW_VERSION" => "0.0.0",
        "HTTP_ACCESS_TOKEN" => "abc123",
        "HTTP_HEIGHT" => 480,
        "HTTP_HOST" => "test.io",
        "HTTP_ID" => device.mac_address,
        "HTTP_REFRESH_RATE" => 100,
        "HTTP_USER_AGENT" => "test",
        "HTTP_WIDTH" => 800
      }
    end

    it "logs errors when parameters are invalid" do
      action.call Rack::MockRequest.env_for("", headers)
      expect(logger).to have_received(:error).with(logs: ["is missing"])
    end
  end
end
