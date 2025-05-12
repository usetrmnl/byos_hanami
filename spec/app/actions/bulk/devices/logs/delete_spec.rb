# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Bulk::Devices::Logs::Delete do
  subject(:action) { described_class.new }

  describe "#call" do
    it "answers unprocessable entity without device ID" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
