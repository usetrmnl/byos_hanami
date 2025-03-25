# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Repositories::DeviceLog, :db do
  subject(:repository) { described_class.new }

  let(:log) { Factory[:device_log] }

  describe "#all" do
    it "answers records" do
      log
      expect(repository.all).to contain_exactly(log)
    end

    it "answers empty array when records don't exist" do
      expect(repository.all).to eq([])
    end
  end

  describe "#find" do
    it "answers record by ID" do
      expect(repository.find(log.id)).to eq(log)
    end

    it "answers nil for unknown ID" do
      expect(repository.find(13)).to be(nil)
    end

    it "answers nil for nil ID" do
      expect(repository.find(nil)).to be(nil)
    end
  end
end
