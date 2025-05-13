# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Firmware::Delete do
  using Refinements::Pathname

  subject(:action) { described_class.new }

  include_context "with main application"

  describe "#call" do
    it "answers success with valid parameters" do
      settings.firmware_root.join("0.0.0.bin").touch
      response = action.call version: "0.0.0"

      expect(response).to have_attributes(status: 200, body: [""])
    end

    it "answers not found with invalid version" do
      response = action.call version: "0.0.0"
      expect(response).to have_attributes(status: 404, body: ["Unable to delete Version 0.0.0."])
    end

    it "answers unprocessable entity with invalid ID" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
