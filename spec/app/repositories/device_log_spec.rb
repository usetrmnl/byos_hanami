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

  describe "#all_by_device" do
    it "answers records" do
      expect(repository.all_by_device(log.device_id)).to contain_exactly(
        have_attributes(id: log.id, device_id: log.device_id)
      )
    end

    it "answers empty array when records don't exist" do
      expect(repository.all_by_device(13)).to eq([])
    end
  end

  describe "#all_by_message" do
    it "answers records for device ID and message" do
      expect(repository.all_by_message(log.device_id, "danger")).to contain_exactly(
        have_attributes(id: log.id, device_id: log.device_id, message: "Danger!")
      )
    end

    it "answers empty array for invalid device ID and valid message" do
      expect(repository.all_by_message(13, "Danger!")).to eq([])
    end

    it "answers empty array for valid device ID and invalid message" do
      expect(repository.all_by_message(log.device_id, "bogus")).to eq([])
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

  describe "#delete_by_device" do
    it "deletes record when given device and record IDs" do
      repository.delete_by_device log.device_id, log.id
      expect(repository.find(log.id)).to be(nil)
    end

    it "doesn't delete record for invalid device ID and valid log ID" do
      repository.delete_by_device nil, log.id
      expect(repository.find(log.id)).to eq(log)
    end

    it "doesn't delete record for valid device ID and invalid log ID" do
      repository.delete_by_device log.device_id, 13
      expect(repository.find(log.id)).to eq(log)
    end
  end

  describe "#delete_logs" do
    it "deletes associated logs" do
      id = log.device_id
      repository.delete_all_by_device id

      expect(repository.all).to eq([])
    end
  end
end
