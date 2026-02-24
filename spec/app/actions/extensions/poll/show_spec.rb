# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Extensions::Poll::Show, :db do
  subject(:action) { described_class.new fetcher: }

  let(:fetcher) { instance_double Terminus::Aspects::Extensions::MultiFetcher, call: result }
  let(:result) { Success Terminus::Aspects::Extensions::Capsule.new }

  describe "#call" do
    let(:extension) { Factory[:extension, uris: ["https://one.io"]] }

    let :response do
      action.call Rack::MockRequest.env_for(
        extension.id.to_s,
        "router.params" => {extension_id: extension.id}
      )
    end

    context "with success (non-image kind)" do
      let :result do
        Success Terminus::Aspects::Extensions::Capsule[
          content: {"source_1" => {"data" => [{"name" => "test"}]}}
        ]
      end

      it "renders data" do
        expect(response.body.first).to match(/name.+test/)
      end
    end

    context "with success (image kind)" do
      let(:extension) { Factory[:extension, kind: "image", uris: ["https://one.io"]] }

      let :result do
        Success Terminus::Aspects::Extensions::Capsule[content: {"source" => "Image test."}]
      end

      it "renders data" do
        expect(response.body.first).to match(/source.+Binary request\.\.\./)
      end
    end

    context "with failure" do
      let :result do
        Failure Terminus::Aspects::Extensions::Capsule[
          content: nil,
          errors: {"https://test.io" => "Danger!"}
        ]
      end

      it "renders error" do
        expect(response.body.first).to include(<<~HTML)
          <textarea id="extension_response" class="bit-editor" data-mode="read" data-language="json">
          </textarea>
        HTML
      end
    end

    it "answers not found error with invalid ID" do
      response = action.call Hash.new
      expect(response.status).to eq(404)
    end
  end
end
