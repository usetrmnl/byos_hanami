# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Extensions::Update do
  subject(:action) { described_class.new }

  describe "#call" do
    it "answers unprocessable entity for unknown ID" do
      response = action.call id: 666
      expect(response.status).to eq(422)
    end
  end
end
