# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Devices::Index, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:device) { Factory[:device] }

    it "renders standard response with search results" do
      response = Rack::MockRequest.new(action).get "", params: {query: device.label}
      expect(response.body).to include(%(<h2 class="label">Test</h2>))
    end

    it "renders standard response with no results" do
      response = Rack::MockRequest.new(action).get "", params: {query: "bogus"}
      expect(response.body).to include("No devices found.")
    end

    it "renders htmx response with search results" do
      response = Rack::MockRequest.new(action).get "",
                                                   "HTTP_HX_TRIGGER" => "search",
                                                   params: {query: device.label}

      expect(response.body).to include(%(<h2 class="label">Test</h2>))
    end

    it "renders htmx response with no results" do
      response = Rack::MockRequest.new(action).get "",
                                                   "HTTP_HX_TRIGGER" => "search",
                                                   params: {query: "bogus"}

      expect(response.body).to include("No devices found.")
    end

    it "renders all devices with no query" do
      device
      response = Rack::MockRequest.new(action).get "", "HTTP_HX_TRIGGER" => "search"

      expect(response.body).to include(%(<h2 class="label">Test</h2>))
    end
  end
end
