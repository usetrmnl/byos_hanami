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
          body: nil,
          fields: nil,
          template: nil,
          globals: nil,
          repeat_interval: 1,
          repeat_days: [],
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
