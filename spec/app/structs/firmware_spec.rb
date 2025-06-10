# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Firmware, :db do
  subject(:firmware) { Factory[:firmware] }

  let(:repository) { Terminus::Repositories::Firmware.new }

  let :attached do
    path = temp_dir.join "test.bin"
    path.binwrite [123].pack("N")
    repository.update firmware.id, attachment: Shrine.upload(path.open, :store).data
  end

  include_context "with temporary directory"

  describe "#file_name" do
    it "answers file name" do
      expect(attached.file_name).to eq("test.bin")
    end
  end

  describe "#file_size" do
    it "answers file size" do
      expect(attached.file_size).to eq(4)
    end
  end

  describe "#mime_type" do
    it "answers mime_type" do
      expect(attached.mime_type).to eq("application/octet-stream")
    end
  end

  describe "#attachment_attributes" do
    it "answers empty attributes without attachment" do
      expect(firmware.attachment_attributes).to eq({})
    end

    it "answers attributes with attachment" do
      update = Hanami.app["repositories.firmware"].create version: "0.0.0", attachment: {a: 1}
      expect(update.attachment_attributes).to eq(a: 1)
    end
  end

  describe "#attachment_id" do
    it "answers ID" do
      expect(attached.attachment_id).to match(/\h{32}\.bin/)
    end
  end

  describe "#attachment_uri" do
    it "answers URI" do
      expect(attached.attachment_uri).to match(%r(memory://\h{32}\.bin))
    end
  end

  describe "#attach" do
    it "attaches file" do
      path = temp_dir.join "test.bin"
      path.binwrite [123].pack("N")

      upload = firmware.attach path.open

      expect(upload.data).to match(
        "id" => /\h{32}\.bin/,
        "metadata" => {
          "filename" => "test.bin",
          "height" => nil,
          "size" => 4,
          "mime_type" => "application/octet-stream",
          "width" => nil
        },
        "storage" => "cache"
      )
    end
  end

  describe "#upload" do
    it "uploads file when valid" do
      path = temp_dir.join "test.bin"
      path.binwrite [123].pack("N")

      upload = firmware.upload path.open

      expect(upload.data).to match(
        "id" => /\h{32}\.bin/,
        "metadata" => {
          "filename" => "test.bin",
          "height" => nil,
          "size" => 4,
          "mime_type" => "application/octet-stream",
          "width" => nil
        },
        "storage" => "store"
      )
    end

    it "doesn't upload file when invalid" do
      upload = firmware.upload StringIO.new

      expect(upload.data).to match(
        "id" => /\h{32}/,
        "metadata" => {
          "filename" => nil,
          "height" => nil,
          "size" => 0,
          "mime_type" => nil,
          "width" => nil
        },
        "storage" => "cache"
      )
    end
  end

  describe "#valid_attachment?" do
    it "answers true with no errors" do
      path = temp_dir.join "test.bin"
      path.binwrite [123].pack("N")
      firmware.attach path.open

      expect(firmware.valid_attachment?).to be(true)
    end

    it "answers false with errors" do
      firmware.attach StringIO.new
      expect(firmware.valid_attachment?).to be(false)
    end
  end
end
