# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Extensions::Edit, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:extension) { Factory[:extension] }

    it "answers 200 OK status with valid parameters" do
      response = action.call id: extension.id
      expect(response.status).to eq(200)
    end

    it "answers errors with invalid parameters" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
