# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Repositories::Device, :db do
  subject(:repository) { described_class.new }

  let(:device) { Factory[:device] }

  describe "#find" do
    it "answers record by ID" do
      expect(repository.find(device.id)).to eq(device)
    end

    it "answers nil for unknown ID" do
      expect(repository.find(13)).to be(nil)
    end
  end

  describe "#find_by_api_key" do
    it "answers record for API key" do
      expect(repository.find_by_api_key(device.api_key)).to eq(device)
    end

    it "answers nil for unknown ID" do
      expect(repository.find_by_api_key(13)).to be(nil)
    end
  end

  describe "#find_by_mac_address" do
    it "answers record for API key" do
      expect(repository.find_by_mac_address(device.mac_address)).to eq(device)
    end

    it "answers nil for unknown ID" do
      expect(repository.find_by_mac_address(13)).to be(nil)
    end
  end

  describe "#all" do
    it "answers all records" do
      device
      expect(repository.all).to contain_exactly(device)
    end

    it "answers empty array when records don't exist" do
      expect(repository.all).to eq([])
    end
  end
end
