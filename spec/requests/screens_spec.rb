# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "/api/screens", :db do
  let(:device) { Factory[:device] }
  let(:path) { temp_dir.join device.slug, "rspec_test.png" }

  it "creates image from HTML with random name" do
    post routes.path(:api_screens_create),
         {image: {content: "<p>Test</p>"}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(Pathname(json_payload[:path]).exist?).to be(true)
  end

  it "creates image from HTML with specific name" do
    post routes.path(:api_screens_create),
         {image: {content: "<p>Test</p>", file_name: "test.bmp"}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(Pathname(json_payload[:path]).exist?).to be(true)
  end

  it "creates image from URI" do
    post routes.path(:api_screens_create),
         {image: {uri: SPEC_ROOT.join("support/fixtures/test.png")}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(Pathname(json_payload[:path]).exist?).to be(true)
  end

  it "creates image from Base64 encoded data" do
    data = Base64.strict_encode64 SPEC_ROOT.join("support/fixtures/test.png").read

    post routes.path(:api_screens_create),
         {image: {data:}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(Pathname(json_payload[:path]).exist?).to be(true)
  end

  it "creates image with specific dimensions" do
    post routes.path(:api_screens_create),
         {image: {uri: SPEC_ROOT.join("support/fixtures/test.png"), dimensions: "50x100!"}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    image = MiniMagick::Image.open Pathname(json_payload[:path])

    expect(image).to have_attributes(width: 50, height: 100)
  end

  it "answers bad request for unknown device" do
    post routes.path(:api_screens_create),
         {image: {content: "<p>Test</p>"}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => "bogus"

    expect(last_response.status).to eq(400)
  end

  it "answers bad request for no body" do
    post routes.path(:api_screens_create),
         {},
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => "bogus"

    expect(last_response.status).to eq(400)
  end

  it "answers errors for partial body" do
    post routes.path(:api_screens_create),
         {image: {file_name: "test"}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(json_payload).to eq(
      error: %(Invalid screen parameters: {dimensions: "800x480", file_name: "test"}.)
    )
  end

  it "answers bad request for partial body" do
    post routes.path(:api_screens_create),
         {image: {file_name: "test"}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(last_response.status).to eq(400)
  end

  context "with invalid file name" do
    before do
      post routes.path(:api_screens_create),
           {image: {content: "Test.", file_name: "test"}}.to_json,
           "CONTENT_TYPE" => "application/json",
           "HTTP_ACCESS_TOKEN" => device.api_key
    end

    it "answers bad request status" do
      expect(last_response.status).to eq(400)
    end

    it "answers error" do
      expect(json_payload).to match(error: /invalid image type/i)
    end
  end
end
