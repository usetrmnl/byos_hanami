# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Screens::Create, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:model) { Factory[:model] }

    let :params do
      {
        screen: {
          model_id: model.id,
          label: "Test",
          name: "test"
        }
      }
    end

    it "renders default response" do
      response = Rack::MockRequest.new(action).post("", params:)
      expect(response.body).to include("<!DOCTYPE html>")
    end

    it "renders htmx response" do
      response = Rack::MockRequest.new(action).post("", "HTTP_HX_REQUEST" => "true", params:)
      expect(response.body).to have_htmx_title("Screens")
    end
  end
end
