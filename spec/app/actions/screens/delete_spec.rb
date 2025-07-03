# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Screens::Delete, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:screen) { Factory[:screen] }

    it "answers success with valid parameters" do
      response = action.call id: screen.id
      expect(response).to have_attributes(status: 200, body: [""])
    end

    it "answers unprocessable entity with invalid ID" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
