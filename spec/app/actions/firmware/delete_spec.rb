# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Firmware::Delete, :db do
  subject(:action) { described_class.new }

  include_context "with main application"

  describe "#call" do
    let(:firmware) { Factory[:firmware] }

    it "answers success with valid ID" do
      response = action.call id: firmware.id
      expect(response).to have_attributes(status: 200, body: [""])
    end

    it "answers not found with invalid ID" do
      response = action.call id: 13
      expect(response).to have_attributes(status: 200, body: [""])
    end

    it "answers unprocessable entity with invalid ID" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
