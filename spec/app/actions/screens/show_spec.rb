# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Screens::Show, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:screen) { Factory[:screen, :with_image] }

    it "renders default response" do
      response = action.call Rack::MockRequest.env_for(
        screen.id.to_s,
        "router.params" => {id: screen.id}
      )

      expect(response.body.first).to include("<!DOCTYPE html>")
    end

    it "renders htmx response" do
      response = action.call Rack::MockRequest.env_for(
        screen.id.to_s,
        "HTTP_HX_REQUEST" => "true",
        "router.params" => {id: screen.id}
      )

      expect(response.body.first).to have_htmx_title(/Screen \d+ Screen/)
    end

    it "answers unprocessable entity with invalid parameters" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
