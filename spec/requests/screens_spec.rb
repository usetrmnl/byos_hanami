# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "/api/screens", :db do
  using Refinements::Pathname

  include_context "with JWT"

  let(:model) { Factory[:model] }
  let(:screen) { Factory[:screen, :with_image] }

  it "answers records when screens exist" do
    screen

    get routes.path(:api_screens),
        {},
        "HTTP_AUTHORIZATION" => access_token,
        "CONTENT_TYPE" => "application/json"

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
          bit_depth: 1,
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
    get routes.path(:api_screens),
        {},
        "HTTP_AUTHORIZATION" => access_token,
        "CONTENT_TYPE" => "application/json"

    expect(json_payload).to eq(data: [])
  end

  it "creates image from HTML" do
    post routes.path(:api_screen_create),
         {screen: {model_id: model.id, label: "Test", name: "test", content: "<p>n/a</p>"}}.to_json,
         "HTTP_AUTHORIZATION" => access_token,
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
        bit_depth: 1,
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
      screen: {
        model_id: model.id,
        label: "Test",
        name: "test",
        uri: SPEC_ROOT.join("support/fixtures/test.png"),
        preprocessed: true
      }
    }

    post routes.path(:api_screen_create),
         payload.to_json,
         "HTTP_AUTHORIZATION" => access_token,
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
        bit_depth: 1,
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
      screen: {
        model_id: model.id,
        label: "Test",
        name: "test",
        uri: SPEC_ROOT.join("support/fixtures/test.png")
      }
    }

    post routes.path(:api_screen_create),
         payload.to_json,
         "HTTP_AUTHORIZATION" => access_token,
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
        bit_depth: 1,
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
         {screen: {model_id: model.id, label: "Test", name: "test", data:}}.to_json,
         "HTTP_AUTHORIZATION" => access_token,
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
        bit_depth: 1,
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
           {screen: {model_id: 666, label: "Test", name: "test", content: "<p>Test.</p>"}}.to_json,
           "HTTP_AUTHORIZATION" => access_token,
           "CONTENT_TYPE" => "application/json"
    end

    it "answers problem details" do
      problem = Petail[
        type: "/problem_details#screen_payload",
        status: 422,
        title: "Unprocessable Content",
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
    let(:model) { Factory[:model, mime_type: "text/html"] }

    before do
      post routes.path(:api_screen_create),
           {screen: {model_id: model.id, label: "Test", name: "test", content: "test"}}.to_json,
           "HTTP_AUTHORIZATION" => access_token,
           "CONTENT_TYPE" => "application/json"
    end

    it "answers problem details" do
      problem = Petail[
        type: "/problem_details#screen_payload",
        status: :unprocessable_content,
        detail: "Unsupported MIME Type: text/html.",
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
      post routes.path(:api_screen_create),
           {},
           "HTTP_AUTHORIZATION" => access_token,
           "CONTENT_TYPE" => "application/json"
    end

    it "answers problem details" do
      problem = Petail[
        type: "/problem_details#screen_payload",
        status: :unprocessable_content,
        detail: "Validation failed.",
        instance: "/api/screens",
        extensions: {errors: {screen: ["is missing"]}}
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
          {screen: {content: "<p>Test</p>"}}.to_json,
          "HTTP_AUTHORIZATION" => access_token,
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
        bit_depth: 1,
        size: kind_of(Integer),
        width: 800,
        height: 480,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  it "patches screen with Base64 encoded data" do
    data = Base64.strict_encode64 SPEC_ROOT.join("support/fixtures/test.png").read

    patch routes.path(:api_screen_patch, id: screen.id),
          {screen: {data:}}.to_json,
          "HTTP_AUTHORIZATION" => access_token,
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
        bit_depth: 1,
        size: kind_of(Integer),
        width: 800,
        height: 480,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  it "patches screen with preprocessed URI" do
    payload = {screen: {uri: SPEC_ROOT.join("support/fixtures/test.png").to_s, preprocessed: true}}

    patch routes.path(:api_screen_patch, id: screen.id),
          payload.to_json,
          "HTTP_AUTHORIZATION" => access_token,
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
        bit_depth: 1,
        size: kind_of(Integer),
        width: 1,
        height: 1,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  it "patches screen with unprocessed URI" do
    payload = {screen: {uri: SPEC_ROOT.join("support/fixtures/test.png").to_s}}

    patch routes.path(:api_screen_patch, id: screen.id),
          payload.to_json,
          "HTTP_AUTHORIZATION" => access_token,
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
        bit_depth: 1,
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
          {screen: {model_id: model.id}}.to_json,
          "HTTP_AUTHORIZATION" => access_token,
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
        bit_depth: 1,
        size: kind_of(Integer),
        width: 1,
        height: 1,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  it "answers problem details for invalid model ID" do
    patch routes.path(:api_screen_patch, id: screen.id),
          {screen: {model_id: 666, content: "<h1>Test</h2>"}}.to_json,
          "HTTP_AUTHORIZATION" => access_token,
          "CONTENT_TYPE" => "application/json"

    problem = Petail[
      type: "/problem_details#screen_payload",
      status: 422,
      title: "Unprocessable Content",
      detail: "Unable to find model for ID: 666.",
      instance: "/api/screens"
    ]

    expect(json_payload).to eq(problem.to_h)
  end

  context "with invalid Base64 data" do
    before do
      patch routes.path(:api_screen_patch, id: screen.id),
            {screen: {data: "invalid-base64-data!!!"}}.to_json,
            "HTTP_AUTHORIZATION" => access_token,
            "CONTENT_TYPE" => "application/json"
    end

    it "answers problem details" do
      expect(json_payload).to include(
        type: "/problem_details#screen_payload",
        status: 422,
        title: "Unprocessable Content"
      )
    end

    it "answers detail with Base64 error" do
      expect(json_payload[:detail]).to match(/Invalid Base64 data/)
    end
  end

  it "answers problem details for unsupported model" do
    model = Factory[:model, mime_type: "image/webp"]

    patch routes.path(:api_screen_patch, id: screen.id),
          {screen: {model_id: model.id, content: "<h1>Test</h2>"}}.to_json,
          "HTTP_AUTHORIZATION" => access_token,
          "CONTENT_TYPE" => "application/json"

    problem = Petail[
      type: "/problem_details#screen_payload",
      status: 422,
      title: "Unprocessable Content",
      detail: "Unsupported MIME Type: image/webp.",
      instance: "/api/screens"
    ]

    expect(json_payload).to eq(problem.to_h)
  end

  it "answers problem details when payload has no content" do
    patch routes.path(:api_screen_patch, id: screen.id),
          {screen: {}}.to_json,
          "HTTP_AUTHORIZATION" => access_token,
          "CONTENT_TYPE" => "application/json"

    problem = Petail[
      type: "/problem_details#screen_payload",
      status: 422,
      title: "Unprocessable Content",
      detail: "Validation failed.",
      instance: "/api/screens",
      extensions: {
        errors: {
          screen: ["must be filled"]
        }
      }
    ]

    expect(json_payload).to eq(problem.to_h)
  end

  it "answers deleted screen" do
    delete routes.path(:api_screen_delete, id: screen.id),
           {},
           "HTTP_AUTHORIZATION" => access_token,
           "CONTENT_TYPE" => "application/json"

    expect(json_payload).to match(
      data: {
        model_id: kind_of(Integer),
        id: kind_of(Integer),
        label: screen.label,
        name: screen.name,
        filename: "test.png",
        uri: "memory://abc123.png",
        mime_type: "image/png",
        bit_depth: 1,
        size: kind_of(Integer),
        width: 1,
        height: 1,
        created_at: match_rfc_3339,
        updated_at: match_rfc_3339
      }
    )
  end

  it "answers not found problem details when deleting non-existing screen" do
    delete routes.path(:api_screen_delete, id: 666),
           {},
           "HTTP_AUTHORIZATION" => access_token,
           "CONTENT_TYPE" => "application/json"

    expect(json_payload).to eq(status: 404, title: "Not Found", type: "about:blank")
  end
end
