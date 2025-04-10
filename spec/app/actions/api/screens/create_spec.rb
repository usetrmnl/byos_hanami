# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::API::Screens::Create, :db do
  subject(:action) { described_class.new settings: }

  include_context "with main application"

  describe "#call" do
    let(:device) { Factory[:device] }
    let(:path) { temp_dir.join device.slug, "rspec_test.bmp" }

    it "creates image with random name" do
      response = Rack::MockRequest.new(action)
                                  .request "GET",
                                           "",
                                           "HTTP_ACCESS_TOKEN" => device.api_key,
                                           params: {image: {content: "<p>Test</p>"}}

      payload = JSON response.body, symbolize_names: true

      expect(Pathname(payload[:path]).exist?).to be(true)
    end

    it "creates image with custom name" do
      response = Rack::MockRequest.new(action)
                                  .request "GET",
                                           "",
                                           "HTTP_ACCESS_TOKEN" => device.api_key,
                                           params: {
                                             image: {
                                               content: "<p>Test</p>",
                                               filename: "rspec_test"
                                             }
                                           }

      payload = JSON response.body, symbolize_names: true

      expect(Pathname(payload[:path]).exist?).to be(true)
    end

    it "answers bad request for unknown device" do
      response = Rack::MockRequest.new(action)
                                  .request "GET",
                                           "",
                                           "HTTP_ACCESS_TOKEN" => "bogus",
                                           params: {image: {content: "<p>Test</p>"}}

      expect(response.status).to eq(400)
    end

    it "answers bad request for no body" do
      response = action.call Hash.new
      expect(response.status).to eq(400)
    end

    it "answers errors for partial body" do
      response = action.call({image: {file_name: "test"}})
      payload = JSON response.body.first, symbolize_names: true

      expect(payload).to eq(image: {content: ["is missing"]})
    end

    it "answers bad request for partial body" do
      response = action.call({image: {file_name: "test"}})
      expect(response.status).to eq(400)
    end
  end
end
