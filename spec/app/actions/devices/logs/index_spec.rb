# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Devices::Logs::Index, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:device_log) { Factory[:device_log] }

    it "answers unprocessable entity status when required parameters are missing" do
      response = Rack::MockRequest.new(action).get ""

      expect(response.status).to eq(422)
    end

    it "renders standard response with search results" do
      response = Rack::MockRequest.new(action).get "", params: {device_id: device_log.device_id}

      expect(response.body).to include("Danger!")
    end

    it "renders standard response with no results" do
      response = Rack::MockRequest.new(action).get "",
                                                   params: {
                                                     device_id: device_log.device_id,
                                                     query: "bogus"
                                                   }

      expect(response.body).to include("No logs found.")
    end

    it "renders htmx response with search results" do
      response = Rack::MockRequest.new(action).get "",
                                                   "HTTP_HX_TRIGGER" => "search",
                                                   params: {device_id: device_log.device_id}

      expect(response.body).to include("Danger!")
    end

    it "renders htmx response with no results" do
      response = Rack::MockRequest.new(action).get "",
                                                   "HTTP_HX_TRIGGER" => "search",
                                                   params: {
                                                     device_id: device_log.device_id,
                                                     query: "bogus"
                                                   }

      expect(response.body).to include("No logs found.")
    end
  end
end
