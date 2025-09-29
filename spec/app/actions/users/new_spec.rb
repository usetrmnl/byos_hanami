# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Users::New do
  subject(:action) { described_class.new }

  describe "#call" do
    it "renders default response" do
      response = Rack::MockRequest.new(action).post("")
      expect(response.body).to include("<!DOCTYPE html>")
    end

    it "renders htmx response" do
      response = Rack::MockRequest.new(action).post("", "HTTP_HX_REQUEST" => "true")
      expect(response.body).to have_htmx_title("New User")
    end
  end
end
