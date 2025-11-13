# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Devices::Edit, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:device) { Factory[:device] }

    it "answers 200 OK status with valid parameters" do
      response = action.call id: device.id
      expect(response.status).to eq(200)
    end

    it "renders htmx response" do
      response = action.call Rack::MockRequest.env_for(
        device.id.to_s,
        "HTTP_HX_REQUEST" => "true",
        "router.params" => {id: device.id}
      )

      expect(response.body.first).to have_htmx_title("Edit Test Device")
    end

    it "answers errors with invalid parameters" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
