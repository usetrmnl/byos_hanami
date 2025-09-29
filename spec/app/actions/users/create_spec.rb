# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Users::Create, :db do
  subject(:action) { described_class.new }

  include_context "with user statuses"

  describe "#call" do
    let(:user) { Factory[:user] }

    let :params do
      {
        user: {
          name: "Test User",
          email: "test@test.io",
          password: "test-1234567890",
          status_1: 1
        }
      }
    end

    it "renders default response" do
      response = Rack::MockRequest.new(action).post("", params:)
      expect(response.body).to include("<!DOCTYPE html>")
    end

    it "renders htmx response" do
      response = Rack::MockRequest.new(action).post("", "HTTP_HX_REQUEST" => "true", params:)
      expect(response.body).to have_htmx_title("Users")
    end
  end
end
