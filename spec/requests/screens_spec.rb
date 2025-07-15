# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "/api/screens", :db do
  using Refinements::Pathname

  let(:device) { Factory[:device] }
  let(:path) { settings.screens_root.join device.slug, "rspec_test.png" }

  it "answers records when screens exist" do
    path.deep_touch

    get routes.path(:api_screens),
        {},
        "CONTENT_TYPE" => "application/json",
        "HTTP_ACCESS_TOKEN" => device.api_key

    expect(json_payload).to eq(
      data: [
        {
          name: "rspec_test.png",
          path: "https://localhost/tmp/rspec/A1B2C3D4E5F6/rspec_test.png"
        }
      ]
    )
  end

  it "answers empty array when screens don't exist" do
    get routes.path(:api_screens),
        {},
        "CONTENT_TYPE" => "application/json",
        "HTTP_ACCESS_TOKEN" => device.api_key

    expect(json_payload).to eq(data: [])
  end

  it "answers empty array when device doesn't exist" do
    get routes.path(:api_screens),
        {},
        "CONTENT_TYPE" => "application/json",
        "HTTP_ACCESS_TOKEN" => "bogus"

    expect(json_payload).to eq(data: [])
  end

  it "creates image from HTML with random name" do
    post routes.path(:api_screens_create),
         {image: {content: "<p>Test</p>"}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(temp_dir.join("A1B2C3D4E5F6/#{json_payload.dig :data, :name}").exist?).to be(true)
  end

  it "creates image from HTML with specific name" do
    post routes.path(:api_screens_create),
         {image: {content: "<p>Test</p>", file_name: "test.bmp"}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(temp_dir.join("A1B2C3D4E5F6/test.bmp").exist?).to be(true)
  end

  it "creates preprocessed image from URI" do
    post routes.path(:api_screens_create),
         {image: {uri: SPEC_ROOT.join("support/fixtures/test.png"), preprocessed: true}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(temp_dir.join("A1B2C3D4E5F6/#{json_payload.dig :data, :name}").exist?).to be(true)
  end

  it "creates unprocessed image from URI" do
    post routes.path(:api_screens_create),
         {image: {uri: SPEC_ROOT.join("support/fixtures/test.png")}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(temp_dir.join("A1B2C3D4E5F6/#{json_payload.dig :data, :name}").exist?).to be(true)
  end

  it "creates image from Base64 encoded data" do
    data = Base64.strict_encode64 SPEC_ROOT.join("support/fixtures/test.png").read

    post routes.path(:api_screens_create),
         {image: {data:}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(temp_dir.join("A1B2C3D4E5F6/#{json_payload.dig :data, :name}").exist?).to be(true)
  end

  it "creates image with specific dimensions" do
    post routes.path(:api_screens_create),
         {image: {uri: SPEC_ROOT.join("support/fixtures/test.png"), dimensions: "50x100!"}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    image = MiniMagick::Image.open temp_dir.join("A1B2C3D4E5F6/#{json_payload.dig :data, :name}")

    expect(image).to have_attributes(width: 50, height: 100)
  end

  it "creates screen and answers name and path" do
    post routes.path(:api_screens_create),
         {image: {content: "<p>Test</p>", file_name: "test.png"}}.to_json,
         "CONTENT_TYPE" => "application/json",
         "HTTP_ACCESS_TOKEN" => device.api_key

    expect(json_payload).to eq(
      data: {
        name: "test.png",
        path: "https://localhost/../tmp/rspec/A1B2C3D4E5F6/test.png"
      }
    )
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
        extensions: {errors: {image: ["is missing"]}}
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

  it "deletes existing screen" do
    path.deep_touch

    delete routes.path(:api_screen_delete, id: path.basename.to_s),
           {},
           "CONTENT_TYPE" => "application/json",
           "HTTP_ACCESS_TOKEN" => device.api_key

    expect(path.exist?).to be(false)
  end

  it "answers deleted screen" do
    path.deep_touch

    delete routes.path(:api_screen_delete, id: path.basename.to_s),
           {},
           "CONTENT_TYPE" => "application/json",
           "HTTP_ACCESS_TOKEN" => device.api_key

    expect(json_payload).to eq(
      data: {
        name: "rspec_test.png",
        path: "https://localhost/tmp/rspec/A1B2C3D4E5F6/rspec_test.png"
      }
    )
  end

  it "answers unknown screen for unknown device" do
    delete routes.path(:api_screen_delete, id: "bogus"),
           {},
           "CONTENT_TYPE" => "application/json",
           "HTTP_ACCESS_TOKEN" => "bogus"

    expect(json_payload).to eq(
      data: {
        name: "unknown.png",
        path: "https://localhost/screens/bogus/unknown.png"
      }
    )
  end

  it "answers non-existing screen" do
    delete routes.path(:api_screen_delete, id: path.basename.to_s),
           {},
           "CONTENT_TYPE" => "application/json",
           "HTTP_ACCESS_TOKEN" => device.api_key

    expect(json_payload).to eq(
      data: {
        name: "rspec_test.png",
        path: "https://localhost/tmp/rspec/A1B2C3D4E5F6/rspec_test.png"
      }
    )
  end
end
