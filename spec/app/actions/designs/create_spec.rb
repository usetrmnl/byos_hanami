# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Designs::Create, :db do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:repository) { Terminus::Repositories::Screen.new }
    let(:model) { Factory[:model] }

    let :parameters do
      {
        model_id: model.id,
        design: {
          label: "Test",
          name: :test,
          content: "<p>Test</p>"
        }
      }
    end

    it "creates screen" do
      Rack::MockRequest.new(action).post "", params: parameters

      expect(repository.find_by(name: "test")).to have_attributes(
        model_id: model.id,
        name: "test",
        label: "Test",
        image_attributes: hash_including(
          metadata: hash_including(
            size: kind_of(Integer),
            width: 800,
            height: 480,
            filename: "test.png",
            mime_type: "image/png"
          )
        )
      )
    end

    it "redirects to edit page" do
      response = Rack::MockRequest.new(action).post "", params: parameters
      expect(response.location).to match(%r(designs/\d+/edit))
    end

    it "answers error when attribute is missing" do
      parameters[:design].delete :label
      response = Rack::MockRequest.new(action).post "", params: parameters

      expect(response.body).to include("is missing")
    end
  end
end
