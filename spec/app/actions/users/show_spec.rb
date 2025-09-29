# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Users::Show, :db do
  subject(:action) { described_class.new }

  include_context "with user statuses"

  describe "#call" do
    let(:user) { Factory[:user] }

    it "renders default response" do
      response = Rack::MockRequest.new(action).get "", params: {id: user.id}
      expect(response.body).to include("<!DOCTYPE html>")
    end

    it "renders htmx response" do
      response = Rack::MockRequest.new(action)
                                  .get "", "HTTP_HX_REQUEST" => "true", params: {id: user.id}

      expect(response.body).to have_htmx_title(user.name)
    end

    it "answers unprocessable entity with invalid parameters" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
