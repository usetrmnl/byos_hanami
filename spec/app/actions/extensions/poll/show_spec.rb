# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Extensions::Poll::Show, :db do
  subject(:action) { described_class.new fetcher: }

  let(:fetcher) { instance_double Terminus::Aspects::Extensions::MultiFetcher, call: result }
  let(:result) { Success({}) }

  describe "#call" do
    let(:extension) { Factory[:extension, uris: ["https://one.io"]] }

    let :response do
      action.call Rack::MockRequest.env_for(
        extension.id.to_s,
        "router.params" => {id: extension.id}
      )
    end

    context "with success" do
      let(:result) { Success "source_1" => Success("data" => [{"name" => "test"}]) }

      it "renders data" do
        expect(response.body.first).to match(/name.+test/)
      end
    end

    context "with outer failure" do
      let(:result) { Failure "Danger!" }

      it "renders error" do
        expect(response.body.first).to include("Danger!")
      end
    end

    context "with inner failure" do
      let(:result) { Success "source_1" => Failure("Danger!") }

      it "renders error" do
        expect(response.body.first).to match("Danger!")
      end
    end

    it "renders empty text area with empty result" do
      expect(response.body.first).to include("{}")
    end

    it "answers not found error with invalid ID" do
      response = action.call Hash.new
      expect(response.status).to eq(404)
    end
  end
end
