# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::API::Screens::Create do
  subject(:action) { described_class.new settings: }

  include_context "with main application"

  let(:path) { temp_dir.join "rspec_test.bmp" }

  describe "#call" do
    it "creates image with random name" do
      body = {image: {content: "<p>Test</p>"}}
      payload = JSON action.call(body).body.first, symbolize_names: true

      expect(Pathname(payload[:path]).exist?).to be(true)
    end

    it "creates image with custom name" do
      body = {image: {content: "<p>Test</p>", file_name: "rspec_test"}}
      payload = JSON action.call(body).body.first, symbolize_names: true

      expect(Pathname(payload[:path]).exist?).to be(true)
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
