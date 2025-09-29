# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Users::Edit, :db do
  subject(:action) { described_class.new }

  include_context "with user statuses"

  describe "#call" do
    let(:user) { Factory[:user] }

    it "answers 200 OK status with valid parameters" do
      response = action.call id: user.id
      expect(response.status).to eq(200)
    end

    it "renders htmx response" do
      response = Rack::MockRequest.new(action)
                                  .get "", "HTTP_HX_REQUEST" => "true", params: {id: user.id}

      expect(response.body).to have_htmx_title("Edit #{user.name}")
    end

    it "answers errors with invalid parameters" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
