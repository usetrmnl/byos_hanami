# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Devices::Show, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:device) { Factory[:device] }

    it "answers 200 OK status with valid parameters" do
      response = action.call id: device.id
      expect(response.status).to eq(200)
    end

    it "renders htmx response" do
      response = Rack::MockRequest.new(action)
                                  .get "", "HTTP_HX_REQUEST" => "true", params: {id: device.id}

      expect(response.body).not_to include("<!DOCTYPE html>")
    end

    it "answers unprocessable entity with invalid parameters" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
