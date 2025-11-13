# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Users::Show, :db do
  subject(:action) { described_class.new }

  include_context "with user statuses"

  describe "#call" do
    let(:user) { Factory[:user] }

    it "renders default response" do
      response = action.call Rack::MockRequest.env_for(
        user.id.to_s,
        "router.params" => {id: user.id}
      )

      expect(response.body.first).to include("<!DOCTYPE html>")
    end

    it "renders htmx response" do
      response = action.call Rack::MockRequest.env_for(
        user.id.to_s,
        "HTTP_HX_REQUEST" => "true",
        "router.params" => {id: user.id}
      )

      expect(response.body.first).to have_htmx_title(user.name)
    end

    it "answers unprocessable entity with invalid parameters" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
