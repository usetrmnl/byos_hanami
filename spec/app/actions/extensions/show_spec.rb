# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Extensions::Show, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:extension) { Factory[:extension] }

    it "renders default response" do
      response = action.call Rack::MockRequest.env_for(
        extension.id.to_s,
        "router.params" => {id: extension.id}
      )

      expect(response.body.first).to include("<!DOCTYPE html>")
    end

    it "renders htmx response" do
      response = action.call Rack::MockRequest.env_for(
        extension.id.to_s,
        "HTTP_HX_REQUEST" => "true",
        "router.params" => {id: extension.id}
      )

      expect(response.body.first).to have_htmx_title("#{extension.label} Extension")
    end

    it "answers unprocessable entity with invalid parameters" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
