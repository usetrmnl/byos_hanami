# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Extensions::Create, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let :params do
      {
        extension: {
          label: "Test",
          name: "test",
          description: nil,
          kind: "poll",
          mode: "light",
          tags: nil,
          headers: nil,
          verb: "get",
          uris: "https://test.io/tests.json",
          poll_body: nil,
          static_body: nil,
          fields: nil,
          padding: false,
          template_full: nil,
          template_horizontal: nil,
          template_vertical: nil,
          template_quarter: nil,
          template_shared: nil,
          repeat_interval: 1,
          repeat_days: nil,
          last_day_of_month: false
        }
      }
    end

    it "renders default response" do
      response = Rack::MockRequest.new(action).post("", params:)
      expect(response.body).to include("<!DOCTYPE html>")
    end

    it "renders htmx response" do
      response = Rack::MockRequest.new(action).post("", "HTTP_HX_REQUEST" => "true", params:)
      expect(response.body).to have_htmx_title("Extensions")
    end
  end
end
