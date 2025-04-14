# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Devices::Index do
  subject(:action) { described_class.new }

  describe "#call" do
    it "renders htmx response" do
      response = Rack::MockRequest.new(action).get "", "HTTP_HX_REQUEST" => "true"

      expect(response.body).not_to include("<!DOCTYPE html>")
    end
  end
end
