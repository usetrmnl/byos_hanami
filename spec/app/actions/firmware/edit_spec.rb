# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Firmware::Edit, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:firmware) { Factory[:firmware] }

    it "answers 200 OK status with valid parameters" do
      response = action.call id: firmware.id
      expect(response.status).to eq(200)
    end

    it "renders htmx response" do
      response = action.call Rack::MockRequest.env_for(
        firmware.id.to_s,
        "HTTP_HX_REQUEST" => "true",
        "router.params" => {id: firmware.id}
      )

      expect(response.body.first).to have_htmx_title("Edit Firmware #{firmware.version}")
    end

    it "answers errors with invalid parameters" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
