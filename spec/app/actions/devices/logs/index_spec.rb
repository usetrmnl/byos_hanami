# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Devices::Logs::Index, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:device_log) { Factory[:device_log] }

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

      expect(response.body).to include("All is quiet")
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

      expect(response.body).to include("All is quiet")
    end
  end
end
