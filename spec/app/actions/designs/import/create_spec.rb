# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Designs::Import::Create, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:exporter) { Terminus::Aspects::Designs::Exporter.new }
    let(:model) { Factory[:model] }
    let(:screen_template) { Factory.structs[:screen_template] }

    it "renders errors when invalid" do
      allow(screen_template).to receive(:export_attributes).and_return({})

      response = action.call Rack::MockRequest.env_for(
        "",
        "router.params" => {
          model_id: model.id,
          design: {
            attachment: {
              name: "test",
              type: "application/zip",
              head: "test",
              filename: "test.zip",
              tempfile: exporter.call(screen_template).value!
            }
          }
        }
      )

      expect(response.flash.inspect).to include("label is missing")
    end

    it "flashs success when valid" do
      response = action.call Rack::MockRequest.env_for(
        "",
        "router.params" => {
          model_id: model.id,
          design: {
            attachment: {
              name: "test",
              type: "application/zip",
              head: "test",
              filename: "test.zip",
              tempfile: exporter.call(screen_template).value!
            }
          }
        }
      )

      expect(response.flash.inspect).to include("Design imported!")
    end

    it "answers unprocessable content when parameters are missing" do
      response = Rack::MockRequest.new(action).post("")
      expect(response.status).to eq(422)
    end
  end
end
