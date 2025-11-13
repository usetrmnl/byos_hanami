# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Models::Show, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:model) { Factory[:model] }

    it "renders default response" do
      response = action.call Rack::MockRequest.env_for(
        model.id.to_s,
        "router.params" => {id: model.id}
      )

      expect(response.body.first).to include("<!DOCTYPE html>")
    end

    it "renders htmx response" do
      response = action.call Rack::MockRequest.env_for(
        model.id.to_s,
        "HTTP_HX_REQUEST" => "true",
        "router.params" => {id: model.id}
      )

      expect(response.body.first).to have_htmx_title("#{model.label} Model")
    end

    it "answers unprocessable entity with invalid parameters" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
