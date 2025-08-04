# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "/api/screens", :db do
  using Refinements::Pathname

  let(:model) { Factory[:model] }
  let(:screen) { Factory[:screen, :with_image] }

  it "answers records when screens exist" do
    screen
    get routes.path(:api_screens), {}, "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: [
        {
          model_id: kind_of(Integer),
          id: kind_of(Integer),
          label: screen.label,
          name: screen.name,
          filename: "test.png",
          uri: "memory://abc123.png",
          mime_type: "image/png",
          size: kind_of(Integer),
          width: 1,
          height: 1,
          created_at: match_rfc_3339,
          updated_at: match_rfc_3339
        }
      ]
    )
  end

  it "answers empty array when screens don't exist" do
    get routes.path(:api_screens), {}, "CONTENT_TYPE" => "application/json"
    expect(json_payload).to eq(data: [])
  end

  it "creates image from HTML" do
    post routes.path(:api_screen_create),
         {image: {model_id: model.id, label: "Test", name: "test", content: "<p>Test</p>"}}.to_json,
         "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: {
        model_id: model.id,
        id: kind_of(Integer),
        label: "Test",
        name: "test",
        filename: "test.png",
        uri: %r(memory://\h{32}.png),
        mime_type: "image/png",
        size: kind_of(Integer),
        width: 800,
        height: 480,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  it "creates preprocessed image from URI" do
    payload = {
      image: {
        model_id: model.id,
        label: "Test",
        name: "test",
        uri: SPEC_ROOT.join("support/fixtures/test.png"),
        preprocessed: true
      }
    }

    post routes.path(:api_screen_create), payload.to_json, "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: {
        model_id: kind_of(Integer),
        id: kind_of(Integer),
        label: "Test",
        name: "test",
        filename: "test.png",
        uri: %r(memory://.+.png),
        mime_type: "image/png",
        size: 81,
        width: 1,
        height: 1,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  it "creates unprocessed image from URI" do
    payload = {
      image: {
        model_id: model.id,
        label: "Test",
        name: "test",
        uri: SPEC_ROOT.join("support/fixtures/test.png")
      }
    }

    post routes.path(:api_screen_create), payload.to_json, "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: {
        model_id: kind_of(Integer),
        id: kind_of(Integer),
        label: "Test",
        name: "test",
        filename: "test.png",
        uri: %r(memory://.+.png),
        mime_type: "image/png",
        size: 126,
        width: 800,
        height: 480,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  it "creates image from Base64 encoded data" do
    data = Base64.strict_encode64 SPEC_ROOT.join("support/fixtures/test.png").read

    post routes.path(:api_screen_create),
         {image: {model_id: model.id, label: "Test", name: "test", data:}}.to_json,
         "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: {
        model_id: kind_of(Integer),
        id: kind_of(Integer),
        label: "Test",
        name: "test",
        filename: "test.png",
        uri: %r(memory://.+.png),
        mime_type: "image/png",
        size: 126,
        width: 800,
        height: 480,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  context "with unknown model" do
    before do
      post routes.path(:api_screen_create),
           {image: {model_id: 666, label: "Test", name: "test", content: "<p>Test.</p>"}}.to_json,
           "CONTENT_TYPE" => "application/json"
    end

    it "answers problem details" do
      problem = Petail[
        type: "/problem_details#screen_payload",
        status: 422,
        title: "Unprocessable Entity",
        detail: "Unable to find model for ID: 666.",
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

  context "with invalid MIME Type" do
    before do
      model = Factory[:model, mime_type: "text/html"]
      post routes.path(:api_screen_create),
           {image: {model_id: model.id, label: "Test", name: "test", content: "test"}}.to_json,
           "CONTENT_TYPE" => "application/json"
    end

    it "answers problem details" do
      problem = Petail[
        type: "/problem_details#screen_payload",
        status: :unprocessable_entity,
        detail: %(Invalid MIME Type: "text/html". Use: "image/bmp" or "image/png".),
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
    before { post routes.path(:api_screen_create), {}, "CONTENT_TYPE" => "application/json" }

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

  it "patches screen content" do
    patch routes.path(:api_screen_patch, id: screen.id),
          {image: {content: "<p>Test</p>"}}.to_json,
          "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: {
        model_id: screen.model_id,
        id: kind_of(Integer),
        label: screen.label,
        name: screen.name,
        filename: "#{screen.name}.png",
        uri: %r(memory://\h{32}.png),
        mime_type: "image/png",
        size: kind_of(Integer),
        width: 800,
        height: 480,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  it "patches screen model ID" do
    patch routes.path(:api_screen_patch, id: screen.id),
          {image: {model_id: model.id}}.to_json,
          "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: {
        model_id: model.id,
        id: kind_of(Integer),
        label: screen.label,
        name: screen.name,
        filename: "test.png",
        uri: "memory://abc123.png",
        mime_type: "image/png",
        size: kind_of(Integer),
        width: 1,
        height: 1,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  it "answers problem details when payload has no content" do
    patch routes.path(:api_screen_patch, id: screen.id),
          {image: {}}.to_json,
          "CONTENT_TYPE" => "application/json"

    problem = Petail[
      type: "/problem_details#screen_payload",
      status: 422,
      title: "Unprocessable Entity",
      detail: "Validation failed.",
      instance: "/api/screens",
      extensions: {
        errors: {
          image: ["must be filled"]
        }
      }
    ]

    expect(json_payload).to eq(problem.to_h)
  end

  it "answers deleted screen" do
    delete routes.path(:api_screen_delete, id: screen.id), {}, "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: {
        model_id: kind_of(Integer),
        id: kind_of(Integer),
        label: screen.label,
        name: screen.name,
        filename: "test.png",
        uri: "memory://abc123.png",
        mime_type: "image/png",
        size: kind_of(Integer),
        width: 1,
        height: 1,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  it "answers not found problem details when deleting non-existing screen" do
    delete routes.path(:api_screen_delete, id: 666), {}, "CONTENT_TYPE" => "application/json"

    expect(json_payload).to eq(status: 404, title: "Not Found", type: "about:blank")
  end
end
