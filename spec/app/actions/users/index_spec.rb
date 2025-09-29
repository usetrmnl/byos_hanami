# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Users::Index, :db do
  subject(:action) { described_class.new }

  include_context "with user statuses"

  describe "#call" do
    let(:user) { Factory[:user, :verified] }

    it "renders standard response with search results" do
      response = Rack::MockRequest.new(action).get "", params: {query: user.name}
      expect(response.body).to include(%(<h2 class="label">#{user.name}</h2>))
    end

    it "renders standard response with no results" do
      response = Rack::MockRequest.new(action).get "", params: {query: "bogus"}
      expect(response.body).to include("No users found.")
    end

    it "renders htmx response with search results" do
      response = Rack::MockRequest.new(action).get "",
                                                   "HTTP_HX_TRIGGER" => "search",
                                                   params: {query: user.name}

      expect(response.body).to include(%(<h2 class="label">#{user.name}</h2>))
    end

    it "renders htmx response with no results" do
      response = Rack::MockRequest.new(action).get "",
                                                   "HTTP_HX_TRIGGER" => "search",
                                                   params: {query: "bogus"}

      expect(response.body).to include("No users found.")
    end

    it "renders all users with no query" do
      user
      response = Rack::MockRequest.new(action).get "", "HTTP_HX_TRIGGER" => "search"

      expect(response.body).to include(%(<h2 class="label">#{user.name}</h2>))
    end
  end
end
