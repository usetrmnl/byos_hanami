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

  context "with unknown device" do
    before do
      post routes.path(:api_screens_create),
           {image: {content: "<p>Test</p>", file_name: "test.bmp"}}.to_json,
           "CONTENT_TYPE" => "application/json",
           "HTTP_ACCESS_TOKEN" => "bogus"
    end

    it "answers problem details" do
      expect(json_payload).to eq(Petail[status: :unauthorized].to_h)
    end

    it "answers content type and status" do
      expect(last_response).to have_attributes(
        content_type: "application/problem+json; charset=utf-8",
        status: 401
      )
    end
  end

  context "without dimensions" do
    before do
      post routes.path(:api_screens_create),
           {image: {file_name: "test.png"}}.to_json,
           "CONTENT_TYPE" => "application/json",
           "HTTP_ACCESS_TOKEN" => device.api_key
    end

    it "answers problem details" do
      problem = Petail[
        type: "/problem_details#screen_payload",
        status: :unprocessable_entity,
        detail: %(Invalid parameters: {dimensions: "800x480", file_name: "test.png"}.),
        instance: "/api/screens"
      ]

      expect(json_payload).to eq(problem.to_h)
    end

    it "answers content type and status" do
      expect(last_response).to have_attributes(
        content_type: "application/problem+json; charset=utf-8",
        status: 422
      )
    end
  end

  context "without file extension" do
    before do
      post routes.path(:api_screens_create),
           {image: {content: "Test.", file_name: "test"}}.to_json,
           "CONTENT_TYPE" => "application/json",
           "HTTP_ACCESS_TOKEN" => device.api_key
    end

    it "answers problem details" do
      problem = Petail[
        type: "/problem_details#screen_payload",
        status: :unprocessable_entity,
        detail: %(Invalid image type: "". Use: "bmp" or "png".),
        instance: "/api/screens"
      ]

      expect(json_payload).to eq(problem.to_h)
    end

    it "answers content type and status" do
      expect(last_response).to have_attributes(
        content_type: "application/problem+json; charset=utf-8",
        status: 422
      )
    end
  end

  context "without body" do
    before do
      post routes.path(:api_screens_create),
           {},
           "CONTENT_TYPE" => "application/json",
           "HTTP_ACCESS_TOKEN" => device.api_key
    end

    it "answers problem details" do
      problem = Petail[
        type: "/problem_details#screen_payload",
        status: :unprocessable_entity,
        detail: "Validation failed.",
        instance: "/api/screens",
        extensions: {image: ["is missing"]}
      ]

      expect(json_payload).to eq(problem.to_h)
    end

    it "answers content type and status" do
      expect(last_response).to have_attributes(
        content_type: "application/problem+json; charset=utf-8",
        status: 422
      )
    end
  end
end
