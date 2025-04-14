# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Devices::Update, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:device) { Factory[:device] }

    it "answers unprocessable entity for unknown device" do
      response = action.call id: 99
      expect(response.status).to eq(422)
    end
  end
end
