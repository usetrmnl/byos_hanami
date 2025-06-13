# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Bulk::Firmware::Delete do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:firmware) { Factory[:firmware] }
    let(:repository) { Terminus::Repositories::Firmware.new }

    it "deletes existing firmware" do
      firmware
      action.call Hash.new

      expect(repository.all).to eq([])
    end

    it "deletes no firmware" do
      action.call Hash.new
      expect(repository.all).to eq([])
    end
  end
end
