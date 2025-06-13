# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Repositories::Firmware, :db do
  subject(:repository) { described_class.new }

  let(:firmware) { Factory[:firmware] }

  describe "#all" do
    it "answers all records" do
      firmware
      two = Factory[:firmware, version: "0.1.0"]

      expect(repository.all).to eq([two, firmware])
    end

    it "answers empty array when records don't exist" do
      expect(repository.all).to eq([])
    end
  end

  describe "#delete" do
    it "deletes existing record" do
      firmware
      repository.delete firmware.id

      expect(repository.all).to eq([])
    end

    it "ignores unknown record" do
      repository.delete 13
      expect(repository.all).to eq([])
    end
  end

  describe "#delete_all" do
    before { firmware }

    it "deletes all records" do
      repository.delete_all
      expect(repository.all).to eq([])
    end

    it "deletes all attachments" do
      upload = firmware.upload StringIO.new([123].pack("N"))
      repository.update firmware.id, attachment_data: upload.data
      repository.delete_all

      expect(Hanami.app[:shrine].storages[:store].store).to eq({})
    end
  end

  describe "#find" do
    it "answers record by ID" do
      expect(repository.find(firmware.id)).to eq(firmware)
    end

    it "answers nil for unknown ID" do
      expect(repository.find(13)).to be(nil)
    end

    it "answers nil for nil ID" do
      expect(repository.find(nil)).to be(nil)
    end
  end

  describe "#latest" do
    it "answers latest record" do
      firmware
      two = Factory[:firmware, version: "0.1.0"]

      expect(repository.latest).to eq(two)
    end

    it "answers nil when records don't exist" do
      expect(repository.latest).to be(nil)
    end
  end

  describe "#find_by_version" do
    it "answers record when found" do
      expect(repository.find_by_version(firmware.version)).to eq(firmware)
    end

    it "answers nil when not found" do
      expect(repository.find_by_version("bogus")).to be(nil)
    end

    it "answers nil for nil" do
      expect(repository.find_by_version(nil)).to be(nil)
    end
  end
end
