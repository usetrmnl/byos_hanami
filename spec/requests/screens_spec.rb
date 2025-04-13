# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "/api/screens", :db do
  let(:device) { Factory[:device] }
  let(:path) { temp_dir.join device.slug, "rspec_test.bmp" }

  it "creates image with random name" do
    post routes.path(:api_screens_create),
         {image: {content: "<p>Test</p>"}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(Pathname(json_payload[:path]).exist?).to be(true)
  end

  it "creates image with specific name" do
    post routes.path(:api_screens_create),
         {image: {content: "<p>Test</p>"}, filename: "test.bmp"}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(Pathname(json_payload[:path]).exist?).to be(true)
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

    expect(json_payload).to eq(image: {content: ["is missing"]})
  end

  it "answers bad request for partial body" do
    post routes.path(:api_screens_create),
         {image: {file_name: "test"}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(last_response.status).to eq(400)
  end
end
