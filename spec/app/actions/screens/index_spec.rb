# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Screens::Index, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:screen) { Factory[:screen, label: "Test", name: "test"] }

    it "renders standard response with search results" do
      response = Rack::MockRequest.new(action).get "", params: {query: screen.label}
      expect(response.body).to include(%(<h2 class="label">Test</h2>))
    end

    it "renders standard response with no results" do
      response = Rack::MockRequest.new(action).get "", params: {query: "bogus"}
      expect(response.body).to include("No screens found.")
    end

    it "renders htmx response with search results" do
      response = Rack::MockRequest.new(action).get "",
                                                   "HTTP_HX_TRIGGER" => "search",
                                                   params: {query: screen.label}

      expect(response.body).to include(%(<h2 class="label">Test</h2>))
    end

    it "renders htmx response with no results" do
      response = Rack::MockRequest.new(action).get "",
                                                   "HTTP_HX_TRIGGER" => "search",
                                                   params: {query: "bogus"}

      expect(response.body).to include("No screens found.")
    end

    it "renders all screens with no query" do
      screen
      response = Rack::MockRequest.new(action).get "", "HTTP_HX_TRIGGER" => "search"

      expect(response.body).to include(%(<h2 class="label">Test</h2>))
    end
  end
end
